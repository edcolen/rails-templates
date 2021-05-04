// Controller example:

// <div data-controller="hello">
//   <input data-hello-target="name" type="text">
//   <button data-action="click->hello#greet">Greet</button>
// </div>

import { Controller } from "stimulus";

export default class extends Controller {
	static targets = ["name"];

	greet() {
		console.log(`Hello, ${this.name}!`);
	}

	get name() {
		return this.nameTarget.value;
	}
}
