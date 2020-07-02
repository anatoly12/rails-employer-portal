document.addEventListener('turbolinks:load', () => {
  const toggleLinkedTo = (select) => {
    document.querySelectorAll(`[data-linked-to-id='${select.id}']`).forEach((div) => {
      console.log(div)
      if(select.value && div.dataset.linkedToValue==select.value){
        div.classList.remove('hidden');
      } else {
        div.classList.add('hidden');
      }
    })
  }
  document.querySelectorAll('select').forEach((select) => {
    select.addEventListener('change', () => toggleLinkedTo(select));
    toggleLinkedTo(select);
  })
})
