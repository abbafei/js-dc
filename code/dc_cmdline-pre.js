var Dc = function(expr){
	var stdout = [];
	var stderr = [];
	(function(){
	var Module = {
		'arguments': ['-e', expr],
		'preRun': function(){FS.init(function(){return null;},undefined,function(something){stderr.push(String.fromCharCode(something))})},
		'print': function(something){stdout.push(something);}}
	;
