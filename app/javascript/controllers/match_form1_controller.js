import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["participants"]
  static values = { players: Array }  

  updateFields(event) {
    const select = event.target
    const selectedOption = select.selectedOptions[0]
    const numPlayers = parseInt(selectedOption.dataset.participantsPerMatch || 0, 10)

    this.participantsTarget.innerHTML = ""

    for (let i = 0; i < numPlayers; i++) {
      const playerSelect = document.createElement("select")
      playerSelect.name = "match[participants][]"      
      
      this.playersValue.forEach(player => {
        const option = document.createElement("option")
        option.value = player.id
        option.textContent = player.name
        playerSelect.appendChild(option)
      })

      const scoreInput = document.createElement("input")
      scoreInput.classList.add('ms-2');
      scoreInput.min = -10000;
      scoreInput.max = 10000;
      scoreInput.step = 0.1;
      scoreInput.type = "number"
      scoreInput.name = `match[scores][]`
      // scoreInput.placeholder = `Player ${i + 1} Score`
      scoreInput.placeholder = `Score`

      const wrapper = document.createElement("div")
      wrapper.classList.add('d-flex', 'flex-row', 'mb-1');
      wrapper.appendChild(playerSelect)
      wrapper.appendChild(scoreInput)

      this.participantsTarget.appendChild(wrapper)
    }
  }
}
