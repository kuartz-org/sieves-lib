import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    filtersPath: String
  }

  static targets = ['submitBtn', 'conjonction']

  updateColumn({ params }) {
    this.submitBtnTarget.innerHTML = "loader"
    this.#getValueInput(params.index).disabled = true

    this.#refreshForm()
  }

  updateOperator({ target, params }) {
    const operatorNeedsInput = !['empty', 'not_empty'].includes(target.value)

    const valueInput = this.#getValueInput(params.index)
    if (operatorNeedsInput) {
      valueInput.style.removeProperty('display')
      valueInput.disabled = false
    } else {
      valueInput.disabled = true
      valueInput.style.display = 'none'
    }
  }

  updateConjonction({ target: { options, selectedIndex }}) {
    const conjonctionText = options[selectedIndex].text
    this.conjonctionTargets.forEach((conjonctionTarget) => {
      conjonctionTarget.innerText = conjonctionText
    })
  }

  #getValueInput(index) {
    return this.element.querySelector(`[data-value-input-index="${index}"]`)
  }

  #refreshForm() {
    const url = new URL(window.origin + this.filtersPathValue)
    const formData = new FormData(this.element)
    for (const [key, value] of formData.entries()) { url.searchParams.append(key, value) }
    for (const field of this.element.elements) { field.disabled = true }

    fetch(url)
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
  }
}
