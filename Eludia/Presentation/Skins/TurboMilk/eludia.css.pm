.form-active-ellipsis {
	FONT-SIZE: 8pt; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	background-color: #ffffff;
}

div.table-container {

      	PADDING-RIGHT: 0px;
      	OVERFLOW-Y: scroll;
      	PADDING-LEFT: 0px;
      	OVERFLOW-X: auto;
      	PADDING-BOTTOM: 0px;
      	MARGIN: 0px;
/*
      	WIDTH: expression(document.body.offsetWidth - (window.name == '_body_iframe' ? 12 : 21));
*/      	
      	WIDTH: expression(document.body.offsetWidth - 16);
      	PADDING-TOP: 0px;      	
      	
	scrollbar-base-color:#d6d3ce;
	scrollbar-arrow-color:#485f70;
	scrollbar-3dlight-color: #efefef;
	scrollbar-darkshadow-color:#b0b0b0;

}

div.checkboxes {

      	OVERFLOW: auto;
      	
	scrollbar-base-color:#d6d3ce;
	scrollbar-arrow-color:#485f70;
	scrollbar-3dlight-color: #efefef;
	scrollbar-darkshadow-color:#b0b0b0;

}

/* Calendar styles */


/* The main calendar widget.  DIV containing a table. */

.calendar {
  position: relative;
  display: none;
  border-top: 2px solid #fff;
  border-right: 2px solid #000;
  border-bottom: 2px solid #000;
  border-left: 2px solid #fff;
  font-size: 11px;
  color: #000;
  cursor: default;
  background: #d4d0c8;
  font-family: tahoma,verdana,sans-serif;
}

.calendar table {
  border-top: 1px solid #000;
  border-right: 1px solid #fff;
  border-bottom: 1px solid #fff;
  border-left: 1px solid #000;
  font-size: 11px;
  color: #000;
  cursor: default;
  background: #d4d0c8;
  font-family: tahoma,verdana,sans-serif;
}

/* Header part -- contains navigation buttons and day names. */

.calendar .button { /* "<<", "<", ">", ">>" buttons have this class */
  text-align: center;
  padding: 1px;
  border-top: 1px solid #fff;
  border-right: 1px solid #000;
  border-bottom: 1px solid #000;
  border-left: 1px solid #fff;
}

.calendar .nav {
  background: transparent url(menuarrow.gif) no-repeat 100% 100%;
}

.calendar thead .title { /* This holds the current "month, year" */
  font-weight: bold;
  padding: 1px;
  border: 1px solid #000;
  background: #848078;
  color: #fff;
  text-align: center;
}

.calendar thead .headrow { /* Row <TR> containing navigation buttons */
}

.calendar thead .daynames { /* Row <TR> containing the day names */
}

.calendar thead .name { /* Cells <TD> containing the day names */
  border-bottom: 1px solid #000;
  padding: 2px;
  text-align: center;
  background: #f4f0e8;
}

.calendar thead .weekend { /* How a weekend day name shows in header */
  color: #f00;
}

.calendar thead .hilite { /* How do the buttons in header appear when hover */
  border-top: 2px solid #fff;
  border-right: 2px solid #000;
  border-bottom: 2px solid #000;
  border-left: 2px solid #fff;
  padding: 0px;
  background-color: #e4e0d8;
}

.calendar thead .active { /* Active (pressed) buttons in header */
  padding: 2px 0px 0px 2px;
  border-top: 1px solid #000;
  border-right: 1px solid #fff;
  border-bottom: 1px solid #fff;
  border-left: 1px solid #000;
  background-color: #c4c0b8;
}

/* The body part -- contains all the days in month. */

.calendar tbody .day { /* Cells <TD> containing month days dates */
  width: 2em;
  text-align: right;
  padding: 2px 4px 2px 2px;
}

.calendar table .wn {
  padding: 2px 3px 2px 2px;
  border-right: 1px solid #000;
  background: #f4f0e8;
}

.calendar tbody .rowhilite td {
  background: #e4e0d8;
}

.calendar tbody .rowhilite td.wn {
  background: #d4d0c8;
}

.calendar tbody td.hilite { /* Hovered cells <TD> */
  padding: 1px 3px 1px 1px;
  border-top: 1px solid #fff;
  border-right: 1px solid #000;
  border-bottom: 1px solid #000;
  border-left: 1px solid #fff;
}

.calendar tbody td.active { /* Active (pressed) cells <TD> */
  padding: 2px 2px 0px 2px;
  border-top: 1px solid #000;
  border-right: 1px solid #fff;
  border-bottom: 1px solid #fff;
  border-left: 1px solid #000;
}

.calendar tbody td.selected { /* Cell showing selected date */
  font-weight: bold;
  border-top: 1px solid #000;
  border-right: 1px solid #fff;
  border-bottom: 1px solid #fff;
  border-left: 1px solid #000;
  padding: 2px 2px 0px 2px;
  background: #e4e0d8;
}

.calendar tbody td.weekend { /* Cells showing weekend days */
  color: #f00;
}

.calendar tbody td.today { /* Cell showing today date */
  font-weight: bold;
  color: #00f;
}

.calendar tbody .disabled { color: #999; }

.calendar tbody .emptycell { /* Empty cells (the best is to hide them) */
  visibility: hidden;
}

.calendar tbody .emptyrow { /* Empty row (some months need less than 6 rows) */
  display: none;
}

/* The footer part -- status bar and "Close" button */

.calendar tfoot .footrow { /* The <TR> in footer (only one right now) */
}

.calendar tfoot .ttip { /* Tooltip (status bar) cell <TD> */
  background: #f4f0e8;
  padding: 1px;
  border: 1px solid #000;
  background: #848078;
  color: #fff;
  text-align: center;
}

.calendar tfoot .hilite { /* Hover style for buttons in footer */
  border-top: 1px solid #fff;
  border-right: 1px solid #000;
  border-bottom: 1px solid #000;
  border-left: 1px solid #fff;
  padding: 1px;
  background: #e4e0d8;
}

.calendar tfoot .active { /* Active (pressed) style for buttons in footer */
  padding: 2px 0px 0px 2px;
  border-top: 1px solid #000;
  border-right: 1px solid #fff;
  border-bottom: 1px solid #fff;
  border-left: 1px solid #000;
}

/* Combo boxes (menus that display months/years for direct selection) */

.combo {
  position: absolute;
  display: none;
  width: 4em;
  top: 0px;
  left: 0px;
  cursor: default;
  border-top: 1px solid #fff;
  border-right: 1px solid #000;
  border-bottom: 1px solid #000;
  border-left: 1px solid #fff;
  background: #e4e0d8;
  font-size: smaller;
  padding: 1px;
}

.combo .label,
.combo .label-IEfix {
  text-align: center;
  padding: 1px;
}

.combo .label-IEfix {
  width: 4em;
}

.combo .active {
  background: #c4c0b8;
  padding: 0px;
  border-top: 1px solid #000;
  border-right: 1px solid #fff;
  border-bottom: 1px solid #fff;
  border-left: 1px solid #000;
}

.combo .hilite {
  background: #048;
  color: #fea;
}

.calendar td.time {
  border-top: 1px solid #000;
  padding: 1px 0px;
  text-align: center;
  background-color: #f4f0e8;
}

.calendar td.time .hour,
.calendar td.time .minute,
.calendar td.time .ampm {
  padding: 0px 3px 0px 4px;
  border: 1px solid #889;
  font-weight: bold;
  background-color: #fff;
}

.calendar td.time .ampm {
  text-align: center;
}

.calendar td.time .colon {
  padding: 0px 2px 0px 3px;
  font-weight: bold;
}

.calendar td.time span.hilite {
  border-color: #000;
  background-color: #766;
  color: #fff;
}

.calendar td.time span.active {
  border-color: #f00;
  background-color: #000;
  color: #0f0;
} 



BODY {
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	FONT-WEIGHT: normal; 
	FONT-SIZE: 8pt; 
	COLOR: #000000; 
	background-color: #FFFFFF
}

.header_0 {
	FONT-WEIGHT: bold; 
	FONT-SIZE: 12pt; 
	COLOR: #63a014; 
	FONT-FAMILY: 'Trebuchet MS', 'MS Sans Serif'; 
}

.header_1 {
	FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR: #2f3237; FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
}

.header_2 {
	FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR: #ffffff; FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
}

.header_3 {
	FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR: #2f3237; FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
}

.header_4 {
	FONT-WEIGHT: normal; 
	FONT-SIZE: 25pt; 
	COLOR: #484e9d; 
	FONT-FAMILY: 'Trebuchet MS', 'MS Sans Serif'; 
}

.header_5 {
	FONT-WEIGHT: normal; 
	FONT-SIZE: 16pt; 
	COLOR: #7c7c7c; 
	FONT-FAMILY: 'Trebuchet MS', 'MS Sans Serif'; 
}

.bgr8 {
	FONT-SIZE: 8pt; FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
}

A.button, A.button:link, A.button:active, A.button:hover, A.button:visited {
	FONT-WEIGHT: normal; FONT-SIZE: 8pt; COLOR: #232324; FONT-FAMILY: Tahoma, 'MS Sans Serif'; TEXT-DECORATION: none
}


a.main-menu, a.main-menu:link, a.main-menu:active, a.main-menu:visited, a.main-menu:hover {
	font-family: Tahoma, 'MS Sans Serif';
	FONT-WEIGHT: bold; 
	font-size: 8pt; 
	color: #ffffff; 
	text-decoration: none;
}

a.tab-0, a.tab-0:link, a.tab-0:active, a.tab-0:visited, a.tab-0:hover {
	font-family: Tahoma, 'MS Sans Serif';
	FONT-WEIGHT: normal; 
	font-size: 8pt; 
	color: #363638; 
	text-decoration: none;
}

a.tab-1, a.tab-1:link, a.tab-1:active, a.tab-1:visited, a.tab-1:hover {
	font-family: Tahoma, 'MS Sans Serif';
	FONT-WEIGHT: normal; 
	font-size: 8pt; 
	color: #000000; 
	text-decoration: none;
}

A.path, A.path:link, A.path:active, A.path:hover, A.path:visited {
	FONT-WEIGHT: normal; 
	FONT-SIZE: 8pt; 
/*	
	COLOR: #000000; 
*/	
	COLOR: #23385a; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
	TEXT-DECORATION: underline;
}

.txt0 {
	FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR: #000000; FONT-FAMILY: Tahoma, 'MS Sans Serif';
}

.txt1 {
	FONT-WEIGHT: normal; FONT-SIZE: 8pt; COLOR: #000000; FONT-FAMILY: Tahoma, 'MS Sans Serif';
}

.txt2 {
	FONT-WEIGHT: normal; FONT-SIZE: 8pt; COLOR: #323233; FONT-FAMILY: Tahoma, 'MS Sans Serif';
}

.bgr0 {
	FONT-SIZE: 8pt; FONT-FAMILY: Tahoma, 'MS Sans Serif'; background-color: #b9c5d7;
}

td.main-menu {
	padding-top:1px;
	padding-bottom:1px;
	background-image: url(/i/_skins/TurboMilk/menu_bg.gif);
	cursor: pointer;
}

td.vert-menu {
	background-color: #454a7c;
	font-family: Tahoma, 'MS Sans Serif';
	font-weight: normal; 
	font-size: 8pt; 
	color: #ffffff; 
	text-decoration: none;
	padding-top:4px;
	padding-bottom:4px;
	background-image: url(/i/_skins/TurboMilk/menu_bg.gif);
	cursor: pointer;

}



.row-cell {
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	FONT-WEIGHT: normal; 
	FONT-SIZE:  10pt; 
	COLOR: #000000; 
	background-color: #ffffff;
	padding-top: 3px;
	padding-bottom: 2px;

	border-right:solid 1px #D6D3CE;
	border-bottom:solid 1px #D6D3CE;


}
.row-cell-transparent {
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	FONT-WEIGHT: normal; 
	FONT-SIZE:  10pt; 
	COLOR: #000000; 
	padding-top: 3px;
	padding-bottom: 2px;

	border-right:solid 1px #D6D3CE;
	border-bottom:solid 1px #D6D3CE;


}
.row-button {
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	FONT-WEIGHT: normal; 
	FONT-SIZE: 10pt; 
	COLOR: #000000; 
	background-color: #efefef;
	padding-top: 3px;
	padding-bottom: 2px;

	border-right:solid 1px #D6D3CE;
	border-bottom:solid 1px #D6D3CE;

}
.row-cell-total {
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	FONT-WEIGHT: bold;   
	FONT-SIZE: 10pt; 
	COLOR: #000000; 
	background-color: #efefef;
	padding-top: 5px;
	padding-bottom: 5px;

}

.row-cell-header {
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	FONT-WEIGHT: bold;   
	FONT-SIZE: 10pt; 
	COLOR: #000000; 
	background-color: #efefef;
	padding-top: 3px;
	padding-bottom: 2px;
	
	position: relative;
	top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);

	border-right:solid 1px #D6D3CE;
	border-bottom:solid 1px #D6D3CE;
	border-top:solid 1px #D6D3CE;

}

.row-cell-hilite {
	background-color: #dededc;
}

A.lnk0, A.lnk0:link, A.lnk0:active, A.lnk0:hover, A.lnk0:visited {
	FONT-SIZE: 8pt; 
	COLOR: #000000; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
	TEXT-DECORATION: none;
}

A.lnk4, A.lnk4:link, A.lnk4:active, A.lnk4:hover, A.lnk4:visited {
	FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
	FONT-WEIGHT: bold;   
	FONT-SIZE:  8pt; 
	COLOR: #000000; 
	TEXT-DECORATION: none
}

A.lnk15 {
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	FONT-SIZE: 10pt; 
	COLOR: #293869; 
	TEXT-DECORATION: none;
	border:none;

	background-color: transparent;
}

A.row-cell, A.row-cell:link, A.row-cell:active, A.row-cell:hover, A.row-cell:visited {
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	FONT-SIZE: 10pt; 
	COLOR: #293869; 
	TEXT-DECORATION: none;
	border:none;

	background-color: transparent;
}
A.row-button, A.row-button:link, A.row-button:active, A.row-button:hover, A.row-button:visited {
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	FONT-SIZE: 10pt; 
	COLOR: #000000; 
	TEXT-DECORATION: none;
	border:none;

	background-color: transparent;
}


.form-active-label, .form-passive-label {
	FONT-WEIGHT: bold; 
	FONT-SIZE:  8pt; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	COLOR: #000000; 
	background-color: #ececec;

	padding-left: 10px;
	padding-right: 10px;
	padding-top: 5px;
	padding-bottom: 5px;

	border-color: #d6d3ce;
	border-style:solid;

	border-left-width: 0px; 
	border-top-width: 0px;
	border-right-width: 1px; 
	border-bottom-width: 1px;
}








.form-deleted-label {
	FONT-WEIGHT: bold; 
	FONT-SIZE:  8pt; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	COLOR: #000000; 
	background-color: #dadae0;
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 5px;
	padding-bottom: 5px;

	border-color: #d6d3ce;
	border-style:solid;

	border-left-width: 0px; 
	border-top-width: 0px;
	border-right-width: 1px; 
	border-bottom-width: 1px;

}

.form-deleted-inputs {
	FONT-SIZE:  8pt; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	background-color: #dadae0;
	padding-left: 5px;
	padding-right: 10px;

	border-color: #d6d3ce;
	border-style:solid;

	border-left-width: 0px; 
	border-top-width: 0px;
	border-right-width: 1px; 
	border-bottom-width: 1px;

}

A.form-deleted-inputs, A.form-deleted-inputs:link, A.form-deleted-inputs:hover, A.form-deleted-inputs:visited {
	FONT-WEIGHT: normal; 
	FONT-SIZE:  8pt; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	background-color: #dadae0;
	COLOR: #293869; 
	TEXT-DECORATION: none;
	padding-left: 0px;
	padding-right: 0px;

	border-color: #d6d3ce;
	border-style:solid;

	border-left-width: 0px; 
	border-top-width: 0px;
	border-right-width: 1px; 
	border-bottom-width: 1px;

}




















.form-inner {
	FONT-SIZE:  8pt; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
}

.form-active-inputs, .form-passive-inputs {
	FONT-SIZE:  8pt; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	background-color: #f9f9ff;
	padding-left: 5px;
	padding-right: 10px;

	border-color: #d6d3ce;
	border-style:solid;

	border-left-width: 0px; 
	border-top-width: 0px;
	border-right-width: 1px; 
	border-bottom-width: 1px;
}

A.form-active-inputs, A.form-active-inputs:link, A.form-active-inputs:hover, A.form-active-inputs:visited, A.form-passive-inputs, A.form-passive-inputs:link, A.form-passive-inputs:hover, A.form-passive-inputs:visited{
	FONT-SIZE:  8pt; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif';
	COLOR: #293869; 
	background-color: #f9f9ff;
	padding-left: 0px;
	padding-right: 0px;
	TEXT-DECORATION: none;
	border-style:none;
}

INPUT {
	FONT-SIZE: 8pt; 
	COLOR: #000000; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif';  
	border-bottom: 2px ridge; 
	border-right: 2px ridge; 
	border-top: 2px inset; 
	border-left: 2px inset;
	padding-left: 1px;
}

.cbx {
	border: 0px none; 
}

SELECT {
	FONT-SIZE: 8pt; 
	COLOR: #000000; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
	border-bottom: 2px ridge; 
	border-right: 2px ridge; 
	border-top: 2px inset; 
	border-left: 2px inset;
}

input.form-active-inputs, select.form-active-inputs, textarea.form-active-inputs {
	FONT-SIZE: 8pt; 
	COLOR: #000000; 
	background-color: #ffffff;
	FONT-FAMILY: Tahoma, 'MS Sans Serif';  
	border-bottom: 2px ridge; 
	border-right: 2px ridge; 
	border-top: 2px inset; 
	border-left: 2px inset;
	padding-left: 1px;

}

td.toolbar {
	FONT-SIZE: 8pt; 
	COLOR: #000000; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
	TEXT-DECORATION: none;
	background-color: #b9c5d7;
}

a.hint {
	FONT-WEIGHT: normal; 
	FONT-SIZE: 8pt; 
	COLOR: #3a6ebb; 
	FONT-FAMILY: Tahoma, 'MS Sans Serif'; 
}











#admin {width:205px;height:25px;padding:5px 5px 5px 9px;background:url('/i/_skins/TurboMilk/menu_button.gif') no-repeat 0 0;}
#admin a {color:#000000;text-decoration:none;font-family: Tahoma, Verdana, sans-serif;font-size:8pt;font-style:normal}

#Menu {position:absolute;top:expression(document.getElementById('admin').offsetTop+25);left:expression(document.getElementById('admin').offsetLeft + document.getElementById('admin').offsetParent.offsetLeft);visibility:expression(subsets_are_visible ? 'visible' : 'hidden');z-index:100;}
#Menu .mm {background-color:#C4C7C9;padding:6px 5px 6px 9px;border-bottom:solid 1px #E2E3E4;}
#Menu .mm0 {background-color:#C4C7C9;padding:6px 5px 0px 9px;}
#Menu a {color:#23385A;text-decoration:none;font-family: Tahoma, Verdana, sans-serif;font-size:8pt;font-style:normal}
#Menu a:hover {color:#23385A;text-decoration:underline;font-family: Tahoma, Verdana, sans-serif;font-size:8pt;font-style:normal}

td.login-head {background:url('/i/_skins/TurboMilk/login_title_pix.gif') repeat-x 1 1 #B9C5D7;font-size:10pt;font-weight:bold;padding:7px;}
td.submit-area {text-align:center;height:36px;background:url('/i/_skins/TurboMilk/submit_area_bgr.gif') repeat-x 0 0;}
div.green-title {color:#ffffff;font-weight:bold;background:url('/i/_skins/TurboMilk/green_ear_left.gif') no-repeat 0 0; width:300px;padding-left:10%;}
div.grey-submit {background:url('/i/_skins/TurboMilk/grey_ear_left.gif') no-repeat 0 0; width:165;min-width:150px;padding-left:20px;}
div.grey-submit a {color:#222323;text-decoration:none;}
div.grey-submit a:hover {color:#222323;text-decoration:underline;}

.logon {font-family: Tahoma, Verdana, sans-serif;font-size:8pt;font-style:normal;font-weight: normal;color:#414141;text-decoration: none;}
