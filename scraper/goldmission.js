var request = require('urllib-sync').request;
var fs = require('fs');

var res = request('http://www.wowhead.com/missions?filter=cr=9;crs=1;crv=0');
var data = res.data.toString();

var output = "missions.lua";

var re = /new Listview\({template: 'mission', id: 'mission', nItemsPerPage: 100, data: (.*?)}\);/;
var match = re.exec(data);
var missions = JSON.parse(match[1]);

var missionsOutput = "mgt_goldMissions = {};\n";

function logMissions(mission, i, array) {
    var id = mission["id"];
    var numCurrencies = mission["rewards"]["currency"].length;
    var reward = 0;
    for (var j = 0; j< numCurrencies; j++) {
        if (mission["rewards"]["currency"][j]["currency"] == 0)
            reward = mission["rewards"]["currency"][j]["amount"];
    }
    missionsOutput = missionsOutput + "mgt_goldMissions[" + id + "]=" + reward + ";\n";
}
missions.forEach(logMissions);

fs.writeFileSync(output, missionsOutput, "utf8");