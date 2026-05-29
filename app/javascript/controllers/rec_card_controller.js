import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wishlistForm", "playedForm", "skipForm"]

  wishlist(event) {
    event.preventDefault()
    this._act("rec-card--action-wishlist", async () => {
      await this._patchGame(this.wishlistFormTarget)
      this._setSkipMessage("ACTION:WISHLISTED — recommend a different game now.")
      this.skipFormTarget.requestSubmit()
    })
  }

  played(event) {
    event.preventDefault()
    this._act("rec-card--action-played", async () => {
      await this._patchGame(this.playedFormTarget)
      this._setSkipMessage("ACTION:PLAYED — recommend a different game now.")
      this.skipFormTarget.requestSubmit()
    })
  }

  skip(event) {
    event.preventDefault()
    this._act("rec-card--action-skip", async () => {
      await this._patchGame(this.wishlistFormTarget, "skipped")
      this._setSkipMessage("ACTION:SKIPPED — recommend a different game now.")
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

  async _patchGame(form, status = null) {
    const formData = new FormData(form)
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    if (csrfToken) formData.set('authenticity_token', csrfToken)
    if (status) formData.set('collection_status', status)
    await fetch(form.action, { method: "POST", body: formData })
  }

  _setSkipMessage(message) {
    const input = this.skipFormTarget.querySelector("input[name='message[content]']")
    if (input) input.value = message
  }
}
