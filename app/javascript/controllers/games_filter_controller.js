import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "sortField", "directionField"]

  handleSortClick(event) {
    event.preventDefault()
    const sortValue = event.currentTarget.dataset.sortValue
    if (sortValue) {
      this.sortFieldTarget.value = sortValue
      this.updateActiveButton('[data-sort-value]', event.currentTarget)
    }
  }

  handleDirectionClick(event) {
    event.preventDefault()
    const directionValue = event.currentTarget.dataset.directionValue
    if (directionValue) {
      this.directionFieldTarget.value = directionValue
      this.updateActiveButton('[data-direction-value]', event.currentTarget)
    }
  }

  submitForm(event) {
    if (event) {
      event.preventDefault()
    }

    const formData = new FormData(this.formTarget)
    const params = new URLSearchParams(formData)

    this.closePanel()
    Turbo.visit(`${this.formTarget.action}?${params.toString()}`)
  }

  clearFilters(event) {
    event.preventDefault()
    this.sortFieldTarget.value = 'title'
    this.directionFieldTarget.value = 'asc'
    this.element.querySelector('#platform').value = ''
    this.element.querySelector('#genre').value = ''
    this.element.querySelector('#studio').value = ''

    this.submitForm()
  }

  closePanel() {
    if (!this.element.classList.contains('d-none')) {
      this.element.classList.add('d-none')
      const button = document.getElementById('games-sort-toggle')
      if (button) button.setAttribute('aria-expanded', 'false')
    }
  }

  updateActiveButton(selector, activeButton) {
    this.element.querySelectorAll(selector).forEach(btn => {
      btn.classList.remove('games-sort-button--active')
    })
    activeButton.classList.add('games-sort-button--active')
  }
}
