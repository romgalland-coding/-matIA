import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  show(event) {
    event.preventDefault()
    const form = event.currentTarget.closest("form")
    const { gameTitle, gameCover } = event.currentTarget.dataset

    const dialog = document.getElementById("turbo-confirm-dialog")
    const coverEl = dialog.querySelector(".confirm-dialog__cover")
    const messageEl = dialog.querySelector(".confirm-dialog__message")

    messageEl.textContent = `Do you want to remove ${gameTitle}?`
    coverEl.style.backgroundImage = gameCover ? `url('${gameCover}')` : "none"
    coverEl.classList.toggle("confirm-dialog__cover--placeholder", !gameCover)

    dialog.showModal()

    const btnConfirm = dialog.querySelector(".confirm-dialog__btn--remove")
    const btnCancel  = dialog.querySelector(".confirm-dialog__btn--cancel")

    const cleanup = () => {
      dialog.close()
      btnConfirm.removeEventListener("click", onConfirm)
      btnCancel.removeEventListener("click", onCancel)
    }
    const onConfirm = () => { cleanup(); form.requestSubmit() }
    const onCancel  = () => cleanup()

    btnConfirm.addEventListener("click", onConfirm)
    btnCancel.addEventListener("click", onCancel)
  }
}
