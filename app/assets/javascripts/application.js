// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.numeric
//= require_tree .
//= require bootstrap

/*This function uses the javascript file jquery.numeric and forces anything with 
the class = positive to be a positive number (decimals allowed)"*/

$(document).ready(function(){
	$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
});


/*This function uses the javascript file found at src="http://yui.yahooapis.com/3.8.1/build/yui/yui-min.js".
Using that source, the below function provides an autocomplete where the source data is yahoo finance.
Anything with the id = 'ac-input' will have this auto complete feature. The input field should also be wrapped in
<div class="container  yui3-skin-sam"> because that will force the autocomplete results to show with a white background.
(otherwise it's transparent and hard to see) */


$(document).ready(function(){YUI({
    filter: 'raw'
}).use("datasource-get", "datasource-jsonschema", "autocomplete", function (Y) {

    var oDS, acNode = Y.one('#ac-input');

    oDS = new Y.DataSource.Get({
        source: "http://d.yimg.com/aq/autoc?query=",
        generateRequestCallback: function (id) {
            YAHOO = {};
            YAHOO.util = {};
            YAHOO.util.ScriptNodeDataSource = {};
            YAHOO.util.ScriptNodeDataSource.callbacks =
                YUI.Env.DataSource.callbacks[id];
            return "&callback=YAHOO.util.ScriptNodeDataSource.callbacks";
        }
    });
    oDS.plug(Y.Plugin.DataSourceJSONSchema, {
        schema: {
            resultListLocator: "ResultSet.Result",
            resultFields: ["symbol", "name", "exch", "type", "exchDisp"]
        }
    });

    acNode.plug(Y.Plugin.AutoComplete, {
        maxResults: 10,
        resultTextLocator: 'symbol',
        resultFormatter: function (query, results) {
            return Y.Array.map(results, function (result) {
                var asset = result.raw;

                return asset.symbol +
                    " " + asset.name +
                    " (" + asset.type +
                    " - " + asset.exchDisp + ")";
            });
        },
        requestTemplate:  "{query}&region=US&lang=en-US",
        source: oDS
    });

    
});
});

$(function(){$('.portfolio-delete').hover(function() {
    $(this).fadeTo(1,1);
 }
,function() {
    $(this).fadeTo(1,0);
});
});

$(function(){$('.portfolio-box').hover(function() {
    $(this).next().fadeTo(1,1);
},function() {
    $(this).next().fadeTo(1,0);
});
});
