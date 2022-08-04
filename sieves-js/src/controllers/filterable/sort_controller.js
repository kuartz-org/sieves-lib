import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  #SORT_INPUT_ID = "filterable_sort"

  static values = {
    formId: String,
    columnName: String,
  }

  sortColumn() {
    const previousSort = this.#filterableFormElement.querySelector(`#${this.#SORT_INPUT_ID}`)
    let order = 'asc'
    if (previousSort && previousSort.dataset.columnName === this.columnNameValue) {
      order = previousSort.value === 'asc' ? 'desc' : 'asc'
    }
    previousSort?.remove()

    this.#filterableFormElement.insertAdjacentHTML("afterbegin", `
    <input type="hidden"
           value="${order}"
           data-column-name="${this.columnNameValue}"
           autocomplete="off"
           name="filterable[sort][${this.columnNameValue}]"
           id="${this.#SORT_INPUT_ID}">
    `)
    this.#filterableFormElement.submit()
  }

  get #filterableFormElement() {
    return document.getElementById(this.formIdValue)
  }
}
