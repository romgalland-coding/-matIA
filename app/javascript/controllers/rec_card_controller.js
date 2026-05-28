import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wishlistForm", "playedForm", "skipForm"]

  wishlist(event) {
    event.preventDefault()
    this._animate("rec-card--action-wishlist", "rec-card--to-wishlist", async () => {
      await this._patchGame(this.wishlistFormTarget)
      this._setSkipMessage("I added this game to my wishlist, recommend me a different game.")
      this.skipFormTarget.requestSubmit()
    })
  }

  played(event) {
    event.preventDefault()
    this._animate("rec-card--action-played", "rec-card--to-played", async () => {
      await this._patchGame(this.playedFormTarget)
      this._setSkipMessage("I already played this game, recommend me a different game.")
      this.skipFormTarget.requestSubmit()
    })
  }

  skip(event) {
    event.preventDefault()
    this._animate("rec-card--action-skip", "rec-card--to-skip", () => {
      this.skipFormTarget.requestSubmit()
    })
  }

  _animate(actionClass, slideClass, callback) {
    this.element.classList.add(actionClass)
    this.element.style.pointerEvents = "none"
    setTimeout(() => this.element.classList.add(slideClass), 80)
    setTimeout(callback, 460)
  }

  async _patchGame(form) {
    await fetch(form.action, { method: "POST", body: new FormData(form) })
  }

  _setSkipMessage(message) {
    const input = this.skipFormTarget.querySelector("input[name='message[content]']")
    if (input) input.value = message
  }
}
