---
title: "ROS 2 + AI Agent: Replacing Robotic Brains with LLMs"
date: 2026-04-14
draft: false
tags: ["ROS2", "Robotics", "LLM", "AI Agent", "Control Systems"]
description: "The era of explicitly coding every robotic movement is over. We experimented with 'LLM-Driven Robot Control,' where an agent understands natural language and translates it into ROS 2 commands."
author: "Henry"
categories: ["Edge AI"]
series: ["Edge AI & Embedded Series"]
series_order: 7
images_needed:
  - position: "hero"
    prompt: "A robotic arm following instructions written on a floating digital tablet. The tablet says 'Pick up the blue ball'. The robot is glowing with neural network lines. Dark mode #0d1117, 16:9"
    file: "images/E/ros2-llm-agent-hero.png"
---

This is Part 7 of the **Edge AI & Embedded Series**.
→ Part 6: [Local LLMs on Raspberry Pi 5: Real-world Tokens Per Second Results](/en/study/E_edge-ai/rpi5-llm-speed-test)

---

In traditional robotics, commanding a robot to "Go to the living room and get the red ball" required thousands of lines of `if-else` statements and complex state machines. In 2026, we have a more elegant way: giving the **control over to the model.**

Today, we share an experimental log of building a robot agent that understands speech by combining **ROS 2** (Robot Operating System) and **LLMs**.

---

### 1. Architecture: LLM as Output

The core is making the LLM generate **'Code or Messages'** rather than mere conversation.
1. **User Input**: "Henry, go to the kitchen and grab some coffee."
2. **LLM Reasoning**: "Kitchen coordinates are (X, Y). I should send this to the Nav2 stack."
3. **ROS 2 Action**: Processed JSON commands are published to ROS 2 topics, and the robot moves.

---

### 2. Why ROS 2?

ROS 2 is a powerful middleware with standardized interfaces for sensors, motor control, and SLAM. By defining each robot function as a **'Tool'** for the LLM, the model just needs to combine these tools based on the situation.

---

### 3. The Challenge: Safety

What if the LLM has a hallucination and commands: "Drive through the wall"? To prevent this, we must have a **'Safety Guardrail Layer'** at the ROS 2 node level. This stage cross-references the LLM's commands with physical constraints (obstacle detection, etc.) before final execution.

---

### Henry's Conclusion: A Shift in Robotics Development

Robot developers will shift from being those who code every scenario in `C++` to those who **define robot functions as APIs accessible to LLMs.** As high-performance NPUs become standard in robotics, standalone robots that think in real-time without the cloud are becoming a reality.

---

**Next:** [ESP32 S3 + OpenAI Whisper: Building a Voice-Recognizing Agent with $10 Chips](/en/study/E_edge-ai/esp32-whisper-voice-agent)
