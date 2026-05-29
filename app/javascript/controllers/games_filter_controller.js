import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "sortField", "directionField", "tabField"]
  static values = { sortValue: String, directionValue: String }

  connect() {
    this.initSortFilterButtons()
    this.initClearButton()
  }

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

  handleSelectChange(event) {
    // Auto-submit when a select changes
    this.submitForm()
  }

  submitForm(event) {
    if (event) {
      event.preventDefault()
    }
    const formData = new FormData(this.formTarget)
    const params = new URLSearchParams(formData)
    
    // Use Turbo to navigate without full page reload
    Turbo.visit(`${this.formTarget.action}?${params.toString()}`)
  }

  clearFilters(event) {
    event.preventDefault()
    document.getElementById('sort-field').value = 'title'
    document.getElementById('direction-field').value = 'asc'
    document.getElementById('platform').value = ''
    document.getElementById('genre').value = ''
    document.getElementById('studio').value = ''
    
    this.submitForm()
  }

  initSortFilterButtons() {
    document.querySelectorAll('[data-sort-value]').forEach(button => {
      button.addEventListener('click', (e) => this.handleSortClick(e))
    })

    document.querySelectorAll('[data-direction-value]').forEach(button => {
      button.addEventListener('click', (e) => this.handleDirectionClick(e))
    })
  }

  initClearButton() {
    const clearButton = document.getElementById('clear-filters-button')
    if (clearButton) {
      clearButton.addEventListener('click', (e) => this.clearFilters(e))
    }
  }

  updateActiveButton(selector, activeButton) {
    document.querySelectorAll(selector).forEach(btn => {
      btn.classList.remove('games-sort-button--active')
    })
    activeButton.classList.add('games-sort-button--active')
  }
}
