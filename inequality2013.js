
var serverurl = "http://daxdigitaldesign.com/capricec/inequality2000/";
//var serverurl = "";

var width = 856,
    height = 650;

var rateById = d3.map();

var startrange = 0.27,
    endrange = 0.61;

var quantize = d3.scale.quantize()
    .domain([startrange, endrange])
    .range(d3.range(6).map(function(i) { return "q" + i + "-9"; }));


var projection = d3.geo.albersUsa()
    .scale(1000)
    .translate([width / 2, height / 2]);

var path = d3.geo.path()
    .projection(projection);

var svg = d3.select("#wrapper7").append("svg")
    .attr("width", width)
    .attr("height", height);

  console.log(quantize);


queue()
    .defer(d3.json, serverurl + "us.json")
    .defer(d3.csv, serverurl + "census_data_2013.csv", function(d) {
      // if(d.Id2[0] === "0"){
      //   d.StateCounty = d.StateCounty.slice(1);
      // }
      rateById.set(d.Id2, +d.Gini);
      })
    .await(ready);

function ready(error, us) {
  svg.append("g")
      .attr("class", "counties")
    .selectAll("path")
      .data(topojson.feature(us, us.objects.counties).features)
    .enter().append("path")
      .attr("class", function(d) {
          return quantize(rateById.get(d.id));
        })
      .attr("d", path);

  svg.append("path")
      .datum(topojson.mesh(us, us.objects.states, function(a, b) {return true; }))
      .attr("class", "states")
      .attr("d", path);

 var legend = svg.append("g")
      .attr("class","legend")
      .attr("x", width - 100)
      .attr("y", 10)
      .attr("height", 100)
      .attr("width", 20);

  for(i=0; i <= 5; i++){
  legend.append("rect")
      .attr("x", width - 100 +i*10)
      .attr("y", 10)
      .attr("width", 10)
      .attr("height", 10)
      .attr("class", "q" + i + "-9");

  legend.append("text")
      .attr("x", width -110)
      .attr("y", 35)
      .text(startrange);

      legend.append("text")
      .attr("x", width -50)
      .attr("y", 35)
      .text(endrange);

};
    d3.select(self.frameElement).style("height", height + "px");
};
