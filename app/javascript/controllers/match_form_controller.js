import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["participants", "submit"]
  static values = { players: Array }

  updateFields(event) {
    const selectedOption = event.target.selectedOptions[0]
    console.log(event.target.options.length) 
    const count = parseInt(selectedOption.dataset.participantsPerMatch || 0, 10)

    this.participantsTarget.innerHTML = ""

    for (let i = 0; i < count; i++) {
      const wrapper = document.createElement("div")
      wrapper.classList.add("participation-fields")

      const playerSelect = document.createElement("select")
      playerSelect.name = `match[participations_attributes][${i}][participant_id]`

      this.playersValue.forEach(player => {
        const option = document.createElement("option")
        option.value = player.id
        option.textContent = player.name
        playerSelect.appendChild(option)
      })

      if (i < playerSelect.options.length) {
      playerSelect.selectedIndex = i;
      }

      const scoreInput = document.createElement("input")
      scoreInput.type = "number"
      scoreInput.name = `match[participations_attributes][${i}][score]`
      scoreInput.min = -9999
      scoreInput.max = 9999
      scoreInput.step = 0.1      
      scoreInput.placeholder = `Player ${i + 1} Score`
      scoreInput.classList.add("ms-1")
      scoreInput.classList.add("score")

      wrapper.appendChild(playerSelect)
      wrapper.appendChild(scoreInput)

      this.participantsTarget.appendChild(wrapper)
    }
      // create submit button dynamically to avoid submission before playerSelect/scoreInput exists
      const submitBtn = document.createElement("input")
      submitBtn.type = 'submit'
      submitBtn.value = 'Create Match'
      this.submitTarget.appendChild(submitBtn)
  }
}

// example build:
/* <div data-match-form-target="participants">
  <div class="participation-fields">
    <select name="match[participations_attributes][0][participant_id]">
      <option value="1">Dan S</option>
      <option value="2">Kev S</option>
      <option value="3">Andy K</option>
    </select>
      <input type="hidden" name="match[participations_attributes][0][participant_type]" value="Player">
      <input type="number" name="match[participations_attributes][0][score]" placeholder="Player 1 Score">
  </div>
  <div class="participation-fields">
    <select name="match[participations_attributes][1][participant_id]">
      <option value="1">Dan S</option>
      <option value="2">Kev S</option>
      <option value="3">Andy K</option>
    </select>
      <input type="hidden" name="match[participations_attributes][1][participant_type]" value="Player">
      <input type="number" name="match[participations_attributes][1][score]" placeholder="Player 2 Score">
  </div>
</div> */