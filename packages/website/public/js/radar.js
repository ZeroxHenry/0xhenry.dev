/**
 * Tech Radar Visualization (D3.js)
 * Ported to Next.js Client Side
 */

(function () {
  const CONFIG = {
    width: 850,
    height: 850,
    blipRadius: 9,
    rings: [
      { name: 'Adopt', color: '#10b981', radius: 150, description: 'Proven technologies for production use.' },
      { name: 'Trial', color: '#6366f1', radius: 260, description: 'Promising tech; ready for pilot projects.' },
      { name: 'Assess', color: '#f59e0b', radius: 360, description: 'Worth exploring for future potential.' },
      { name: 'Hold', color: '#ef4444', radius: 410, description: 'Proceed with caution or avoid for now.' }
    ],
    quadrants: [
      { name: 'AI & ML', color: '#8b5cf6' },
      { name: 'Cloud & Infrastructure', color: '#3b82f6' },
      { name: 'Developer Tools', color: '#f43f5e' },
      { name: 'Platforms & APIs', color: '#10b981' }
    ]
  };

  class TechRadar {
    constructor(containerId, dataUrl) {
      this.container = document.getElementById(containerId);
      this.dataUrl = dataUrl;
      this.data = null;
      this.svg = null;
      this.tooltip = null;
      this.activeQuadrant = null;
    }

    async init() {
      try {
        const response = await fetch(this.dataUrl);
        this.data = await response.json();
        this.createTooltip();
        this.render();
        this.bindResize();
        this.drawLegend();
      } catch (error) {
        console.error('Failed to load radar data:', error);
      }
    }

    createTooltip() {
      this.tooltip = document.createElement('div');
      this.tooltip.className = 'radar-tooltip';
      document.body.appendChild(this.tooltip);
    }

    render() {
      const containerWidth = this.container.offsetWidth;
      const size = Math.min(containerWidth, CONFIG.width);
      const scale = size / CONFIG.width;

      this.container.innerHTML = '';
      this.svg = d3.select(`#${this.container.id}`)
        .append('svg')
        .attr('width', size)
        .attr('height', size)
        .attr('viewBox', `0 0 ${CONFIG.width} ${CONFIG.height}`)
        .attr('class', 'radar-svg');

      const g = this.svg.append('g')
        .attr('transform', `translate(${CONFIG.width / 2}, ${CONFIG.height / 2})`);

      // Draw Rings
      CONFIG.rings.reverse().forEach((ring, i) => {
        g.append('circle')
          .attr('r', ring.radius)
          .attr('class', `radar-ring radar-ring-${3-i}`)
          .attr('fill', 'none')
          .attr('stroke', 'currentColor')
          .attr('stroke-width', 1)
          .attr('opacity', 0.15);
        
        g.append('text')
          .attr('y', -ring.radius + 15)
          .attr('class', 'radar-ring-label')
          .attr('text-anchor', 'middle')
          .attr('fill', 'currentColor')
          .attr('opacity', 0.4)
          .attr('font-size', '12px')
          .attr('font-weight', '600')
          .text(ring.name.toUpperCase());
      });
      CONFIG.rings.reverse(); // Restore order

      // Draw Quadrant Axis
      g.append('line').attr('x1', -CONFIG.width/2).attr('y1', 0).attr('x2', CONFIG.width/2).attr('y2', 0).attr('stroke', 'currentColor').attr('opacity', 0.1);
      g.append('line').attr('x1', 0).attr('y1', -CONFIG.height/2).attr('x2', 0).attr('y2', CONFIG.height/2).attr('stroke', 'currentColor').attr('opacity', 0.1);

      // Draw Quadrant Labels
      const labelOffset = 20;
      const labels = [
        { name: CONFIG.quadrants[0].name, x: -CONFIG.width/2 + labelOffset, y: -CONFIG.height/2 + labelOffset, anchor: 'start' },
        { name: CONFIG.quadrants[1].name, x: CONFIG.width/2 - labelOffset, y: -CONFIG.height/2 + labelOffset, anchor: 'end' },
        { name: CONFIG.quadrants[2].name, x: -CONFIG.width/2 + labelOffset, y: CONFIG.height/2 - labelOffset, anchor: 'start' },
        { name: CONFIG.quadrants[3].name, x: CONFIG.width/2 - labelOffset, y: CONFIG.height/2 - labelOffset, anchor: 'end' }
      ];

      labels.forEach((l, i) => {
        const label = this.svg.append('text')
          .attr('x', l.x > 0 ? l.x : l.x + 850) // Adjust coordinate system
          .attr('y', l.y > 0 ? l.y : l.y + 850)
          .attr('class', 'quadrant-label')
          .attr('text-anchor', l.anchor)
          .attr('fill', CONFIG.quadrants[i].color)
          .attr('font-size', '16px')
          .attr('font-weight', '800')
          .attr('cursor', 'pointer')
          .text(l.name.toUpperCase())
          .on('click', () => this.toggleQuadrant(i));
        
        // Correct position because of g translate
        if (l.x < 0) label.attr('x', Math.abs(l.x));
        else label.attr('x', CONFIG.width - Math.abs(l.x));

        if (l.y < 0) label.attr('y', Math.abs(l.y));
        else label.attr('y', CONFIG.height - Math.abs(l.y));
      });

      // Draw Blips
      this.drawBlips(g);
    }

    drawBlips(g) {
      const blipsGroup = g.append('g').attr('class', 'blips');
      const symbolGenerator = d3.symbol().size(160);

      this.data.blips.forEach((blip) => {
        const quadrant = blip.quadrant;
        const ring = blip.ring;
        const quadrantColor = CONFIG.quadrants[quadrant].color;
        
        // Simplified position calculation for demo (Polar to Cartesian)
        // In real app, we use seed-based jitter
        const angle = (quadrant * 90 + 45) * (Math.PI / 180);
        const ringObj = CONFIG.rings[ring];
        const prevRingRadius = ring > 0 ? CONFIG.rings[ring-1].radius : 0;
        const dist = prevRingRadius + (ringObj.radius - prevRingRadius) * 0.5;
        
        // Jitter based on blip ID to keep it consistent
        const jitterAngle = ((blip.id % 20) - 10) * (Math.PI / 180);
        const jitterDist = (blip.id % 20) - 10;
        
        const pos = {
          x: (dist + jitterDist) * Math.cos(angle + jitterAngle),
          y: (dist + jitterDist) * Math.sin(angle + jitterAngle)
        };

        const blipGroup = blipsGroup.append('g')
          .attr('class', `blip blip-q${quadrant}`)
          .attr('transform', `translate(${pos.x}, ${pos.y})`)
          .attr('cursor', 'pointer');

        // FIXED P0: Ensure symbols render correctly by calling the generator
        if (blip.moved > 0) {
          blipGroup.append('path')
            .attr('d', symbolGenerator.type(d3.symbolTriangle)())
            .attr('fill', quadrantColor)
            .attr('stroke', '#fff')
            .attr('stroke-width', 1.5);
        } else if (blip.moved < 0) {
          blipGroup.append('path')
            .attr('d', symbolGenerator.type(d3.symbolTriangle)())
            .attr('transform', 'rotate(180)')
            .attr('fill', quadrantColor)
            .attr('stroke', '#fff')
            .attr('stroke-width', 1.5);
        } else {
          blipGroup.append('circle')
            .attr('r', CONFIG.blipRadius)
            .attr('fill', quadrantColor)
            .attr('stroke', '#fff')
            .attr('stroke-width', 1.5);
        }

        blipGroup.append('text')
          .attr('text-anchor', 'middle')
          .attr('dominant-baseline', 'central')
          .attr('fill', '#fff')
          .attr('font-size', '8px')
          .attr('font-weight', 'bold')
          .text(blip.id);

        blipGroup
          .on('mouseenter', (event) => this.showTooltip(event, blip))
          .on('mouseleave', () => this.hideTooltip())
          .on('click', () => { if(blip.link) window.location.href = blip.link; });
      });
    }

    showTooltip(event, blip) {
      this.tooltip.innerHTML = `
        <div style="font-weight:800;margin-bottom:4px">${blip.name}</div>
        <div style="font-size:12px;opacity:0.9">${blip.description}</div>
      `;
      this.tooltip.style.display = 'block';
      this.tooltip.style.left = `${event.pageX + 15}px`;
      this.tooltip.style.top = `${event.pageY - 15}px`;
      this.tooltip.classList.add('visible');
    }

    hideTooltip() {
      this.tooltip.classList.remove('visible');
      this.tooltip.style.display = 'none';
    }

    toggleQuadrant(index) {
      if (this.activeQuadrant === index) {
        this.activeQuadrant = null;
        this.svg.selectAll('.blip').style('opacity', 1);
      } else {
        this.activeQuadrant = index;
        this.svg.selectAll('.blip').style('opacity', 0.1);
        this.svg.selectAll(`.blip-q${index}`).style('opacity', 1);
      }
    }

    bindResize() {
      window.addEventListener('resize', () => this.render());
    }

    drawLegend() {
      // Logic for side list if needed
    }
  }

  window.initRadar = function(containerId, dataUrl) {
    const radar = new TechRadar(containerId, dataUrl);
    radar.init();
  };
})();
