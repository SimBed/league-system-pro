import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  cancel(event) {
    event.target.closest('form').classList.add('hidden');
    event.preventDefault();
  }
}
