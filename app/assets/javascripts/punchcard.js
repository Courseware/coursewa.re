//= require d3

( function ( win, $ ) {

  'use strict';

  var $doc = $( document );

  win.Punchcard = {
    element: '.punchcard',
    url: win.location.pathname + '.json',
    days: ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'],
    data: [],
    width: 550,
    height: 400,
    x: null,
    y: null,
    chart: null,
    fontSize: 10,

    setupX: function() {
      return d3.scale.linear().domain([0, 23])
        .range([0, this.width - (this.width / 24) - 40]);
    },

    setupY: function() {
      return d3.scale.linear().domain([0, 6])
        .range([0, this.height - (this.height / 7) - ( this.width / 24)]);
    },

    setupChart: function() {
      return d3.select(this.element).append('svg')
        .attr('class', 'chartf')
        .attr('width', this.width)
        .attr('height', this.height)
        .append('g')
        .attr('transform', 'translate(40, 20)');
    },

    renderX: function() {
      var self = this;

      this.chart.selectAll('.xrule')
        .data(this.x.ticks(24))
        .enter().append('text')
          .attr('class', 'xrule')
          .attr('x', function(d) { return self.x(d) + 15; } )
          .attr('y', 0)
          .attr('dy', -3)
          .attr('text-anchor', 'middle')
          .attr('font-size', this.fontSize)
          .text( function(h){ return h; } );
    },

    renderY: function() {
      var self = this;

      this.chart.selectAll('.yrule')
        .data(this.y.ticks(7))
        .enter().append('text')
          .attr('class', 'yrule')
          .attr('x', 0)
          .attr('y', function(d){ return self.y(d) + self.width/24 + 3; } )
          .attr('dx', -25)
          .attr('text-anchor', 'middle')
          .attr('font-size', 10)
          .text( function(d){ return self.days[parseInt(d, 10)]; } );
    },

    loadData: function(callback) {
      var self = this;
      var counts = {}, sorted = [], data = [];

      for (var i=0; i < 7; i++) {
        counts[i] = {};
        for (var j=0; j < 24; j++) {
          counts[i][j] = 0;
        }
      }

      $.ajax({
        url: self.url,
        dataType: 'json',
        success: function(events) {
          if (events.length > 0) {

            $.each(events, function(index, event) {
              var date = new Date(event.created_at);
              counts[date.getDay()][date.getHours()]++;
            });

            $.each(counts, function(day) {
              $.each(counts[day], function(hour) {
                sorted.push({
                  'day': parseInt(day, 10),
                  'hour': parseInt(hour, 10),
                  'count': counts[day][hour]
                });
              });
            });

            // Filter empty data
            $.each(sorted, function(index, value) {
              if (value.count > 0) {
                data.push(value)
              }
            });

            callback(data, self);
          }
        }
      });
    },

    renderChartData: function(data, scope) {
      self = scope;

      if ( data.length > 0 ) {
        var max = $.map(data, function(d) { return d.count; });
        max = Math.max.apply(null, max);

        var r = d3.scale.linear()
          .domain([0, max])
          .range([0, self.width/48]);

        var circ = self.chart.selectAll('circle')
          .data(data, function(d) { return "" + d.hour + d.day; });

        circ.enter().append('circle')
          .attr('cx', function(d) { return self.x(d.hour) + 15; })
          .attr('cy', function(d) { return self.y(d.day) + self.width/24; })
          .attr('r', function(d) { return 0; })
          .style('fill', '#444');

        circ.transition()
          .duration(1000)
          .attr('r', function(d) { return r(d.count); });

        circ.exit().transition()
          .duration(1000)
          .attr('r', function(d) { return 0; })
          .remove('circle');
      } else {
        alert('Sorry no data yet.')
      }
    },

    run: function() {
      this.x = this.setupX();
      this.y = this.setupY();
      this.chart = this.setupChart();

      this.renderX();
      this.renderY();

      this.loadData(this.renderChartData);

      return this;
    }
  };

  $doc.ready( function() {
    win.Punchcard.run();
  } );

}( window, jQuery ));
