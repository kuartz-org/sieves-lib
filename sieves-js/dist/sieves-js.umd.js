!function(e,t){"object"==typeof exports&&"undefined"!=typeof module?t(exports,require("@hotwired/stimulus")):"function"==typeof define&&define.amd?define(["exports","@hotwired/stimulus"],t):t((e||self).sievesJs={},e.stimulus)}(this,function(e,t){function n(e,t){e.prototype=Object.create(t.prototype),e.prototype.constructor=e,r(e,t)}function r(e,t){return r=Object.setPrototypeOf?Object.setPrototypeOf.bind():function(e,t){return e.__proto__=t,e},r(e,t)}function o(e){if(void 0===e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return e}function i(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,r=new Array(t);n<t;n++)r[n]=e[n];return r}function a(e,t){var n="undefined"!=typeof Symbol&&e[Symbol.iterator]||e["@@iterator"];if(n)return(n=n.call(e)).next.bind(n);if(Array.isArray(e)||(n=function(e,t){if(e){if("string"==typeof e)return i(e,t);var n=Object.prototype.toString.call(e).slice(8,-1);return"Object"===n&&e.constructor&&(n=e.constructor.name),"Map"===n||"Set"===n?Array.from(e):"Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)?i(e,t):void 0}}(e))||t&&e&&"number"==typeof e.length){n&&(e=n);var r=0;return function(){return r>=e.length?{done:!0}:{done:!1,value:e[r++]}}}throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}var u=0;function l(e){return"__private_"+u+++"_"+e}function s(e,t){if(!Object.prototype.hasOwnProperty.call(e,t))throw new TypeError("attempted to use private field on non-instance");return e}var c=/*#__PURE__*/l("getValueInput"),f=/*#__PURE__*/l("refreshForm"),d=/*#__PURE__*/function(e){function t(){for(var t,n=arguments.length,r=new Array(n),i=0;i<n;i++)r[i]=arguments[i];return t=e.call.apply(e,[this].concat(r))||this,Object.defineProperty(o(t),f,{value:m}),Object.defineProperty(o(t),c,{value:p}),t}n(t,e);var r=t.prototype;return r.updateColumn=function(e){var t=e.params;this.submitBtnTarget.innerHTML="loader",s(this,c)[c](t.index).disabled=!0,s(this,f)[f]()},r.updateOperator=function(e){var t=e.params,n=!["empty","not_empty"].includes(e.target.value),r=s(this,c)[c](t.index);n?(r.style.removeProperty("display"),r.disabled=!1):(r.disabled=!0,r.style.display="none")},r.updateConjonction=function(e){var t=e.target,n=t.options[t.selectedIndex].text;this.conjonctionTargets.forEach(function(e){e.innerText=n})},t}(t.Controller);function p(e){return this.element.querySelector('[data-value-input-index="'+e+'"]')}function m(){for(var e,t=new URL(window.origin+this.filtersPathValue),n=a(new FormData(this.element).entries());!(e=n()).done;){var r=e.value;t.searchParams.append(r[0],r[1])}for(var o,i=a(this.element.elements);!(o=i()).done;)o.value.disabled=!0;fetch(t).then(function(e){return e.text()}).then(function(e){return Turbo.renderStreamMessage(e)})}d.values={filtersPath:String},d.targets=["submitBtn","conjonction"];var h=/*#__PURE__*/l("SORT_INPUT_ID"),y=/*#__PURE__*/l("filterableFormElement"),b=/*#__PURE__*/function(e){function t(){for(var t,n=arguments.length,r=new Array(n),i=0;i<n;i++)r[i]=arguments[i];return t=e.call.apply(e,[this].concat(r))||this,Object.defineProperty(o(t),y,{get:v,set:void 0}),Object.defineProperty(o(t),h,{writable:!0,value:"filterable_sort"}),t}return n(t,e),t.prototype.sortColumn=function(){var e=s(this,y)[y].querySelector("#"+s(this,h)[h]),t="asc";e&&e.dataset.columnName===this.columnNameValue&&(t="asc"===e.value?"desc":"asc"),null==e||e.remove(),s(this,y)[y].insertAdjacentHTML("afterbegin",'\n    <input type="hidden"\n           value="'+t+'"\n           data-column-name="'+this.columnNameValue+'"\n           autocomplete="off"\n           name="filterable[sort]['+this.columnNameValue+']"\n           id="'+s(this,h)[h]+'">\n    '),s(this,y)[y].submit()},t}(t.Controller);function v(){return document.getElementById(this.formIdValue)}b.values={formId:String,columnName:String};var g={"filterable--form":d,"filterable--sort":b};e.controllersRegistration=function(e){Object.values(g).forEach(function(t){e.register(t.name,t)})}});
//# sourceMappingURL=sieves-js.umd.js.map
