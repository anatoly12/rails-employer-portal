
import Tagify from '@yaireo/tagify'

document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('input[data-tagging]').forEach((input) => {
    var tagify = new Tagify(input);
    // tagify.addTags(["banana", "orange", "apple"]);
  })
})
