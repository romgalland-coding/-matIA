import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autoscroll"
export default class extends Controller {
  connect() {
    this.element.scrollTop = this.element.scrollHeight
  }
}
