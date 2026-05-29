import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  get sidebar() {
    return this.element.querySelector(".chat-sidebar")
  }

  open() {
    this.sidebar.classList.add("chat-sidebar--open")
  }

  close() {
    this.sidebar.classList.remove("chat-sidebar--open")
  }
}
