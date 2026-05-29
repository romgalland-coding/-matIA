import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ownedSection", "wishlistSection"]

  toggle() {
    const activeTab = document.querySelector(".games-tab--active")?.dataset.tab
    if (activeTab === "owned" && this.hasOwnedSectionTarget) {
      this.ownedSectionTarget.classList.toggle("editing")
    } else if (activeTab === "wishlist" && this.hasWishlistSectionTarget) {
      this.wishlistSectionTarget.classList.toggle("editing")
    }
  }
}
