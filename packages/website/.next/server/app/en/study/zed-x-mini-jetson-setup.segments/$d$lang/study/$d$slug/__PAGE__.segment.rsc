1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T2734,<p>I bought a ZED X Mini for a robotics project. Stereolabs says "connect to Jetson, install SDK, done."</p>
<p>It took me <strong>30 days</strong> to get a single frame.</p>
<p>Not because I'm slow — because the failure mode is <em>silence</em>. No error messages. No crash logs. The camera simply doesn't exist. You plug it in, run the commands, and get... nothing.</p>
<p>This post is everything I learned in that month so nobody else has to repeat it.</p>
<p><img src="/images/study/zed/journey-desk.jpg" alt="The debugging journey — from chaos to a working setup"></p>
<hr>
<h2>The Answer (If You Just Want the Solution)</h2>
<table>
<thead>
<tr>
<th>Component</th>
<th>Version</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Board</strong></td>
<td>Waveshare Orin NX (<strong>22-pin CSI native</strong>)</td>
</tr>
<tr>
<td><strong>JetPack</strong></td>
<td><strong>6.2.1</strong> (L4T 36.4.0)</td>
</tr>
<tr>
<td><strong>ZED SDK</strong></td>
<td>5.2.1</td>
</tr>
<tr>
<td><strong>ZED Link</strong></td>
<td>1.4.0-L4T36.4.0</td>
</tr>
</tbody>
</table>
<p>Installation steps:</p>
<pre><code class="language-bash"># 1. Install ZED Link driver (GMSL2 deserializer)
chmod +x ZED_Link_Driver_L4T36.4.0_v1.4.0.run
sudo ./ZED_Link_Driver_L4T36.4.0_v1.4.0.run
sudo reboot

# 2. Install ZED SDK
chmod +x ZED_SDK_Tegra_L4T36.4_v5.2.1.zstd.run
./ZED_SDK_Tegra_L4T36.4_v5.2.1.zstd.run

# 3. Verify camera
/usr/local/zed/tools/ZED_Explorer
</code></pre>
<blockquote>
<p>Download the <code>.run</code> installers from Stereolabs matching your JetPack version. This is NOT <code>apt install</code>.</p>
</blockquote>
<p>If you're seeing live depth video right now — congratulations, you're done. Close this tab.</p>
<p>If not, keep reading. I've been where you are.</p>
<hr>
<h2>Why This Is Confusing</h2>
<p>The ZED X Mini uses <strong>GMSL2</strong> (Gigabit Multimedia Serial Link), not USB. This means:</p>
<ul>
<li>It connects through the <strong>CSI connector</strong> on the Jetson carrier board</li>
<li>The carrier board needs a <strong>GMSL2 deserializer</strong> chip</li>
<li>The deserializer talks to the Jetson over <strong>I2C bus 9</strong></li>
</ul>
<p>Here's the critical thing nobody tells you: <strong>not all CSI connectors are the same.</strong></p>
<p><img src="/images/study/zed/signal-path.jpeg" alt="The complete signal path: ZED X Mini → GMSL2 Capture Card → Jetson Orin NX"></p>
<p>And here's what the real hardware connection looks like — the GMSL2 capture card sits between the camera and the Jetson board, connected via FFC ribbon cable:</p>
<p><img src="/images/study/zed/capture-card-real.jpeg" alt="Real hardware: Jetson Orin NX connected to GMSL2 capture card via FFC ribbon"></p>
<hr>
<h2>Week 1-2: The Adapter Trap</h2>
<p><img src="/images/study/zed/failure-desk.jpg" alt="The reality of weeks of failed attempts"></p>
<p>My first board was the <strong>Seeed reComputer J4012</strong>. Great board — 15-pin CSI port, compact, well-documented.</p>
<p>The ZED X Mini has a 22-pin connector. So I ordered a 22→15 pin adapter cable. It fits. Physically, everything looks correct.</p>
<pre><code class="language-bash">sudo i2cdetect -y -r 9
</code></pre>
<pre><code>     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:                         -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
</code></pre>
<p>All dashes. The camera doesn't exist on the bus.</p>
<p>I tried:</p>
<ul>
<li>3 different adapter cables</li>
<li>Reseating the connector (multiple times, with magnifying glass)</li>
<li>Different I2C bus numbers (0 through 30)</li>
<li>Kernel device tree modifications</li>
</ul>
<p><strong>Nothing.</strong></p>
<p>The problem isn't the pin count. The 15-pin CSI connector on the reComputer routes different signals than what the GMSL2 deserializer expects. An adapter changes the physical shape but <strong>cannot remap the electrical signals</strong>.</p>
<p><img src="/images/study/zed/csi-connector-comparison.jpeg" alt="15-pin (wrong) vs 22-pin (correct) CSI connectors — they look similar but route completely different signals"></p>
<blockquote>
<p>Think of it like this: you can get a Lightning-to-USB-C adapter, but you can't get a "remap PCIe lanes to I2C" adapter. The protocols are fundamentally different paths on the silicon.</p>
</blockquote>
<hr>
<h2>Week 3: The JetPack Maze</h2>
<p>With a new 22-pin board (Waveshare Orin NX) in hand, I hit the next wall: <strong>which JetPack version?</strong></p>
<p>Stereolabs forums, NVIDIA forums, Reddit threads — everyone has a different answer:</p>
<table>
<thead>
<tr>
<th>Source</th>
<th>Claim</th>
</tr>
</thead>
<tbody>
<tr>
<td>Forum post (2025)</td>
<td>"Only works with JetPack 6.1"</td>
</tr>
<tr>
<td>Stereolabs docs</td>
<td>"Requires JetPack 6.x"</td>
</tr>
<tr>
<td>Reddit user</td>
<td>"I got it working on 6.2.0"</td>
</tr>
<tr>
<td>My experience</td>
<td><strong>Only 6.2.1 actually works</strong></td>
</tr>
</tbody>
</table>
<p>JetPack 6.1 wouldn't even flash successfully on my hardware. JetPack 6.2.0 flashed fine but ZED Link wouldn't install properly — dependency conflicts with the L4T version.</p>
<p>The ZED SDK itself was another headache. You download <code>.run</code> installers from Stereolabs, but <strong>if the SDK version doesn't exactly match your L4T version, the install either fails outright or silently can't find the camera</strong>. Error messages vary wildly:</p>
<pre><code>[ZED SDK] Dependency error: L4T version mismatch
[ZED Link] Kernel module build failed: incompatible kernel headers
</code></pre>
<p>I installed SDK 5.2.0, it conflicted with ZED Link 1.4.0. Downgraded to SDK 5.1.x, then CUDA version mismatch. Change one layer and another breaks.</p>
<p><strong>JetPack 6.2.1</strong> is the one where everything aligns: the L4T kernel version (36.4.0) matches what ZED Link expects, ZED SDK 5.2.1 installs cleanly, the GMSL2 driver loads correctly, and <code>i2cdetect</code> finally shows something.</p>
<hr>
<h2>Week 4: It Works</h2>
<p>After flashing JetPack 6.2.1 on the Waveshare board:</p>
<pre><code class="language-bash">sudo i2cdetect -y -r 9
</code></pre>
<pre><code>     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:                         -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- 2d -- --
30: UU -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
</code></pre>
<p><strong>Addresses visible.</strong> <code>0x2d</code> and <code>0x30 (UU)</code> — that's the GMSL2 deserializer. The camera exists on the bus.</p>
<p>Install:</p>
<pre><code class="language-bash"># ZED Link driver (GMSL2)
chmod +x ZED_Link_Driver_L4T36.4.0_v1.4.0.run
sudo ./ZED_Link_Driver_L4T36.4.0_v1.4.0.run
sudo reboot

# ZED SDK
chmod +x ZED_SDK_Tegra_L4T36.4_v5.2.1.zstd.run
./ZED_SDK_Tegra_L4T36.4_v5.2.1.zstd.run

# Live camera feed
/usr/local/zed/tools/ZED_Explorer
</code></pre>
<p>Depth map, point cloud, everything — first try.</p>
<p><img src="/images/study/zed/depth-success.jpg" alt="Working depth map — the rainbow visualization that took 30 days to see"></p>
<hr>
<h2>The Full Software Stack</h2>
<p><img src="/images/study/zed/stack-visual.jpg" alt="Five-layer software architecture from hardware to application"></p>
<p>Each layer <strong>must match</strong>. The version coupling is tight:</p>
<ul>
<li><strong>ZED Link</strong> is compiled against a specific <strong>L4T kernel version</strong></li>
<li><strong>L4T version</strong> is determined by your <strong>JetPack version</strong></li>
<li><strong>ZED SDK</strong> requires a specific <strong>ZED Link</strong> version</li>
</ul>
<p>If any layer mismatches, the camera silently doesn't exist. No helpful error. Just empty <code>i2cdetect</code>.</p>
<hr>
<h2>Things I Wish I Knew Before Starting</h2>
<ol>
<li>
<p><strong>The adapter cable is a dead end.</strong> If your board has 15-pin CSI, you need a different board. No cable fixes a signal routing mismatch.</p>
</li>
<li>
<p><strong><code>i2cdetect -y -r 9</code> is your diagnostic tool.</strong> Before installing any software, check if the hardware connection works. If bus 9 is empty, don't bother with SDK installation.</p>
</li>
<li>
<p><strong>Don't trust forum version recommendations.</strong> Flash the latest JetPack that Stereolabs officially supports. As of writing, that's 6.2.1.</p>
</li>
<li>
<p><strong>The Waveshare Orin NX carrier board works.</strong> 22-pin CSI with native GMSL2 deserializer. Direct connection, no adapter needed.</p>
</li>
<li>
<p><strong>Flashing JetPack takes ~45 minutes each time.</strong> When you're on your 4th reflash, this adds up. Get the right version first.</p>
</li>
</ol>
<hr>
<h2>My Hardware Setup</h2>
<table>
<thead>
<tr>
<th>Item</th>
<th>What I Used</th>
</tr>
</thead>
<tbody>
<tr>
<td>Camera</td>
<td>ZED X Mini (stereo, GMSL2)</td>
</tr>
<tr>
<td>Compute Module</td>
<td>NVIDIA Jetson Orin NX 16GB</td>
</tr>
<tr>
<td>Carrier Board</td>
<td>Waveshare Orin NX carrier (22-pin CSI)</td>
</tr>
<tr>
<td>Cable</td>
<td>22-pin GMSL2 cable (included with ZED X)</td>
</tr>
<tr>
<td>Power</td>
<td>19V DC barrel jack</td>
</tr>
<tr>
<td>Flash Tool</td>
<td>NVIDIA SDK Manager on Ubuntu 22.04 host</td>
</tr>
</tbody>
</table>
<p>Total time from unboxing to working depth feed: <strong>30 days</strong> (should have been 30 minutes).</p>
<hr>
<p><em>Real hardware notes from a robotics project. Learned the hard way so you don't have to. — Henry</em></p>
<p><em>No affiliation with Stereolabs or NVIDIA.</em></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/en/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","Back to Study"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"ZED X Mini + Jetson Orin NX: 30 Days of Silent Failures"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"I spent a month trying every combination of boards, cables, and JetPack versions to get a ZED X Mini stereo camera running on Jetson. Here's the full story — what failed, why, and the one stack that actually works."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-05"}],["$","span",null,{"children":"7 min read"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","jetson",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"jetson"}],["$","span","zed-camera",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"zed-camera"}],["$","span","robotics",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"robotics"}],["$","span","gmsl2",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"gmsl2"}],["$","span","stereolabs",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stereolabs"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — Robot Education Founder"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"Engineer dedicated to democratizing robot education for everyone. From hardware bring-up to AI integration, I document real learning."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["Follow the journey",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"ZED X Mini + Jetson Orin NX: 30 Days of Silent Failures","slug":"zed-x-mini-jetson-setup","lang":"en"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"zed-x-mini-jetson-setup","lang":"en"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
