import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wishlistForm", "playedForm", "skipForm"]

  wishlist(event) {
    event.preventDefault()
    this._act("rec-card--action-wishlist", async () => {
      await this._patchGame(this.wishlistFormTarget)
      this._setSkipMessage("I added this game to my wishlist, recommend me a different game.")
      this.skipFormTarget.requestSubmit()
    })
  }

  played(event) {
    event.preventDefault()
    this._act("rec-card--action-played", async () => {
      await this._patchGame(this.playedFormTarget)
      this._setSkipMessage("I already played this game, recommend me a different game.")
      this.skipFormTarget.requestSubmit()
    })
  }

  skip(event) {
    event.preventDefault()
    this._act("rec-card--action-skip", () => {
      this.skipFormTarget.requestSubmit()
    })
  }

  _act(colorClass, callback) {
    this.element.classList.add(colorClass)
    const actions = this.element.querySelector(".rec-card__actions")
    if (actions) actions.style.display = "none"
    this.element.style.pointerEvents = "none"
    callback()
  }

  async _patchGame(form) {
    await fetch(form.action, { method: "POST", body: new FormData(form) })
  }

  _setSkipMessage(message) {
    const input = this.skipFormTarget.querySelector("input[name='message[content]']")
    if (input) input.value = message
  }
}
