import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ownedSection"]

  toggle() {
    this.ownedSectionTarget.classList.toggle("editing")
  }
}
