#include-once

Global $_JSGlobal
Global $_JS_ApplyVariable
Global $_JSO
Global $_JSA
Global $_JSExec

_JS_Init()

Func _JSVal($obj)
	return $_JS_ApplyVariable($obj)
EndFunc   ;==>_JSObject

Func _JS_Init()
	if Not IsDeclared('_JSGlobal') Or Not $_JSGlobal Then
			Local $_JS_PreloadScript = 'Object.keys || (Object.keys = function () { "use strict"; var t = Object.prototype.hasOwnProperty, r = !{ toString: null }.propertyIsEnumerable("toString"), e = ["toString", "toLocaleString", "valueOf", "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable", "constructor"], o = e.length; return function (n) { if ("object" != typeof n && ("function" != typeof n || null === n)) throw new TypeError("Object.keys called on non-object"); var c, l, p = []; for (c in n) t.call(n, c) && p.push(c); if (r) for (l = 0; l < o; l++)t.call(n, e[l]) && p.push(e[l]); return p } }());' & @CR & '' & @LF & '"object" != typeof JSON && (JSON = {}), function () { "use strict"; function f(t) { return 10 > t ? "0" + t : t } function quote(t) { return escapable.lastIndex = 0, escapable.test(t) ? ' & "'" & '"' & "'" & ' + t.replace(escapable, function (t) { var e = meta[t]; return "string" == typeof e ? e : "\\u" + ("0000" + t.charCodeAt(0).toString(16)).slice(-4) }) + ' & "'" & '"' & "'" & ' : ' & "'" & '"' & "'" & ' + t + ' & "'" & '"' & "'" & ' } function str(t, e) { var n, r, o, f, u, i = gap, p = e[t]; switch (p && "object" == typeof p && "function" == typeof p.toJSON && (p = p.toJSON(t)), "function" == typeof rep && (p = rep.call(e, t, p)), typeof p) { case "string": return quote(p); case "number": return isFinite(p) ? String(p) : "null"; case "boolean": case "null": return String(p); case "object": if (!p) return "null"; if (gap += indent, u = [], "[object Array]" === Object.prototype.toString.apply(p)) { for (f = p.length, n = 0; f > n; n += 1)u[n] = str(n, p) || "null"; return o = 0 === u.length ? "[]" : gap ? "[\n" + gap + u.join(",\n" + gap) + "\n" + i + "]" : "[" + u.join(",") + "]", gap = i, o } if (rep && "object" == typeof rep) for (f = rep.length, n = 0; f > n; n += 1)"string" == typeof rep[n] && (r = rep[n], o = str(r, p), o && u.push(quote(r) + (gap ? ": " : ":") + o)); else for (r in p) Object.prototype.hasOwnProperty.call(p, r) && (o = str(r, p), o && u.push(quote(r) + (gap ? ": " : ":") + o)); return o = 0 === u.length ? "{}" : gap ? "{\n" + gap + u.join(",\n" + gap) + "\n" + i + "}" : "{" + u.join(",") + "}", gap = i, o } } "function" != typeof Date.prototype.toJSON && (Date.prototype.toJSON = function () { return isFinite(this.valueOf()) ? this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z" : null }, String.prototype.toJSON = Number.prototype.toJSON = Boolean.prototype.toJSON = function () { return this.valueOf() }); var cx, escapable, gap, indent, meta, rep; "function" != typeof JSON.stringify && (escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, meta = { "\b": "\\b", "' & @TAB & '": "\\t", "\n": "\\n", "\f": "\\f", "\r": "\\r", ' & "'" & '"' & "'" & ': ' & "'" & '\\"' & "'" & _
    ', "\\": "\\\\" }, JSON.stringify = function (t, e, n) { var r; if (gap = "", indent = "", "number" == typeof n) for (r = 0; n > r; r += 1)indent += " "; else "string" == typeof n && (indent = n); if (rep = e, e && "function" != typeof e && ("object" != typeof e || "number" != typeof e.length)) throw new Error("JSON.stringify"); return str("", { "": t }) }), "function" != typeof JSON.parse && (cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, JSON.parse = function (text, reviver) { function walk(t, e) { var n, r, o = t[e]; if (o && "object" == typeof o) for (n in o) Object.prototype.hasOwnProperty.call(o, n) && (r = walk(o, n), void 0 !== r ? o[n] = r : delete o[n]); return reviver.call(t, e, o) } var j; if (text = String(text), cx.lastIndex = 0, cx.test(text) && (text = text.replace(cx, function (t) { return "\\u" + ("0000" + t.charCodeAt(0).toString(16)).slice(-4) })), /^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g, ""))) return j = eval("(" + text + ")"), "function" == typeof reviver ? walk({ "": j }, "") : j; throw new SyntaxError("JSON.parse") }) }();' & _
		'Object.prototype.del = function(key){ delete this[key]; return this; };' & _
		'Object.prototype.keys = function(){ return Object.keys(this); };' & _
		'Object.prototype.json = function(v1){ return JSON.stringify(this, 0, v1); };'& _
		'Object.prototype.set = function(k, v){ this[k] = v; return this; };'& _
		'Array.prototype.isArray = function(){ return true };'& _
		'Object.prototype.isArray = function(){ return false };'& _
		'Object.prototype.at = function(k){ return this.hasOwnProperty(k) ? this[k] : null; };' & _
		'function applyVariable(script){ try{ return eval("(" + script + ")"); }catch(e){ return {}; } };' & _
		'function getCreateObjectFunction(a){function b(a){var d={};for(;;){var e=a.args[a.index],f=a.args[a.index+1];if("}"===e)return++a.index,d;if(a.index+=2,"{"===f?d[e]=b(a):"["===f?d[e]=c(a):d[e]=f,a.index>a.maxIndex)return d}}function c(a){var d=[];for(;;){var e=a.args[a.index];if("]"===e)return++a.index,d;if(++a.index,"{"===e?d.push(b(a)):"["===e?d.push(c(a)):d.push(e),a.index>a.maxIndex)return d}}return a?function(){return c({index:0,args:arguments,maxIndex:arguments.length-1})}:function(){return b({index:0,args:arguments,maxIndex:arguments.length-1})}};' & _
		'var createObject = getCreateObjectFunction(false); var createArray = getCreateObjectFunction(true);'

		Global $_JSGlobal = ObjCreate("HTMLFile")
		$_JSGlobal.parentwindow.execScript($_JS_PreloadScript)
		Global $_JSExec = $_JSGlobal.parentwindow.execScript
		Global $_JS_ApplyVariable = $_JSGlobal.parentwindow.applyVariable
		Global $_JSO = $_JSGlobal.parentwindow.createObject
		Global $_JSA = $_JSGlobal.parentwindow.createArray
	EndIf
EndFunc