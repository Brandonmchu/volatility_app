# this just simply changes the add an asset to the portfolio form until the button is clicked, so it's cleaner for users
$(document).ready ->
  $("#add-asset-button").click ->
    $(".asset-form-container").css "display", "block"




###
This function uses the javascript file jquery.numeric and forces anything with 
the class = positive to be a positive number (decimals allowed)

The jquery for this function is:

$(function(){
	$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
});

###

$ ->
  $(".positive").numeric
    negative: false
  , ->
    alert "No negative values"
    @value = ""
    @focus()
    return
  return

###
This function uses the javascript file found at src="http://yui.yahooapis.com/3.8.1/build/yui/yui-min.js".
Using that source, the below function provides an autocomplete where the source data is yahoo finance.
Anything with the id = 'ac-input' will have this auto complete feature. The input field should also be wrapped in
<div class="container  yui3-skin-sam"> because that will force the autocomplete results to show with a white background.
(otherwise it's transparent and hard to see)..... 


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
###

root = exports ? this
root.YAHOO = {}

$(document).ready ->
  YUI(filter: "raw").use "datasource-get", "datasource-jsonschema", "autocomplete", (Y) ->
    oDS = Y.one(".ac-input")
    acNode = Y.one("#ac-input")
    oDS = new Y.DataSource.Get(
      source: "http://d.yimg.com/aq/autoc?query="
      generateRequestCallback: (id) ->
        root.YAHOO = {}
        YAHOO.util = {}
        YAHOO.util.ScriptNodeDataSource = {}
        YAHOO.util.ScriptNodeDataSource.callbacks = YUI.Env.DataSource.callbacks[id]
        "&callback=YAHOO.util.ScriptNodeDataSource.callbacks"
    )
    oDS.plug Y.Plugin.DataSourceJSONSchema,
      schema:
        resultListLocator: "ResultSet.Result"
        resultFields: ["symbol", "name", "exch", "type", "exchDisp"]

    acNode.plug Y.Plugin.AutoComplete,
      maxResults: 10
      resultTextLocator: "symbol"
      resultFormatter: (query, results) ->
        Y.Array.map results, (result) ->
          asset = result.raw
          asset.symbol + " " + asset.name + " (" + asset.type + " - " + asset.exchDisp + ")"

      requestTemplate: "{query}&region=US&lang=en-US"
      source: oDS
    return
  return



###
This function makes the X button on each portfoio box show up whenever the portfolio
box is hovered over. It uses next() because portfolio-delete happens to be the next element
in the dom.

$(function(){$('.portfolio-box').hover(function() {
    $(this).next().fadeTo(1,1);
},function() {
    $(this).next().fadeTo(1,0);
});
});

###

$ ->
  $(".portfolio-box").hover ->
    $(this).next().fadeTo 1, 1
  , ->
    $(this).next().fadeTo 1, 0

###
this function makes the X button on each portfolio box appear when you hover over it. Note that
the above function makes it appear when you are over the Box. However once you hover over the X
you are technically not on the box anymore so the X disappears. That is where this function comes
in. It makes the X appear when you are over the X as well.

$(function(){$('.portfolio-delete').hover(function() {
    $(this).fadeTo(1,1); }
,function() {
    $(this).fadeTo(1,0);
});
});
###

$ ->
  $(".portfolio-delete").hover (->
    $(this).fadeTo 1, 1
  ), ->
    $(this).fadeTo 1, 0

###
 this function makes it so that every time the edit button is clicked, the CSS for various 
 elements go from "inline" to "none". By having input fields which are display:none, I can
 use the below function to quickly make the text field display:none and the input field 
 display:inline. The visual effect is that by clicking the edit button, the fields to edit
 an asset show up. Note that the button also makes the Edit disappear and the Save / Cancel 
 appear

$(document).ready(function(){
    $('.editbutton').click(function(){
        $(this).css('display','none');
        $(this).nextAll('.savebutton').css('display','inline');
        $(this).nextAll('.cancelbutton').css('display','inline');
        $(this).nextAll('.savecancelslash').css('display','inline');
        $(this).closest('tr').find('.assettext').css('display','none');
        $(this).closest('tr').find('.inputfield').css('display','inline');
    });
});
###

$(document).ready ->
  $(".editbutton").click ->
    $(this).css "display", "none"
    $(this).nextAll(".savebutton").css "display", "inline"
    $(this).nextAll(".cancelbutton").css "display", "inline"
    $(this).nextAll(".savecancelslash").css "display", "inline"
    $(this).closest("tr").find(".assettext").css "display", "none"
    $(this).closest("tr").find(".inputfield").css "display", "inline"

###


// This function does the same as the above except for the save button. When someone clicks the
// save button, there is no need to make everything disappear/reappear because saving redirects
// to the same portfolio. However making the cancel button and the '/' before the cancel disappear
// just makes it look more appropriate and gives the user the visual cue that his change is saving

$(document).ready(function(){
    $('.savebutton').click(function(){
        $(this).nextAll('.cancelbutton').css('display','none');
        $(this).nextAll('.savecancelslash').css('display','none');
    });
});
###

$(document).ready ->
  $(".savebutton").click ->
    $(this).nextAll(".cancelbutton").css "display", "none"
    $(this).nextAll(".savecancelslash").css "display", "none"

###
this function does the same as the edit button function except it is for the cancel button. 
Clicking the cancel button makes the cancel & save button disappear through display:none.
It also makes the edit button appear by display:inline. In the same way, the input fields 
disappear and the text appears

$(document).ready(function(){
    $('.cancelbutton').click(function(){
        $(this).css('display','none');
        $(this).closest('td').find('.savebutton').css('display','none');
        $(this).closest('td').find('.editbutton').css('display','inline');
        $(this).closest('td').find('.savecancelslash').css('display','none');
        $(this).closest('tr').find('.assettext').css('display','inline');
        $(this).closest('tr').find('.inputfield').css('display','none');
    });
});
###

$(document).ready ->
  $(".cancelbutton").click ->
    $(this).css "display", "none"
    $(this).closest("td").find(".savebutton").css "display", "none"
    $(this).closest("td").find(".editbutton").css "display", "inline"
    $(this).closest("td").find(".savecancelslash").css "display", "none"
    $(this).closest("tr").find(".assettext").css "display", "inline"
    $(this).closest("tr").find(".inputfield").css "display", "none"