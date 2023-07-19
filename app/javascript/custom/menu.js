// Menu manipulation

// Add toggle listeners to listen for clicks

// document.addEventListener('turbo:load', () => {

//   let hamburger = document.querySelector('#hamburger');
//   hamburger.addEventListener('click', (e) => {
//     e.preventDefault();
//     let menu = document.querySelector('#navbar-menu');
//     menu.classList.toggle('collapse');
//   });

//   let account = document.querySelector('#account');
//   account.addEventListener('click', (e) => {
//     e.preventDefault();
//     let menu = document.querySelector('#dropdown-menu');
//     menu.classList.toggle('active');
//   });
// });

// REFACTOR for DRY

function addToggleListener(element_id, menu_id, toggle_class) {
  let element = document.querySelector(`#${element_id}`);
  element.addEventListener('click', (e) => {
    e.preventDefault();
    let menu = document.querySelector(`#${menu_id}`);
    menu.classList.toggle(toggle_class);
  });
}

document.addEventListener('turbo:load', () => {
  addToggleListener('hamburger', 'navbar-menu', 'collapse');
  addToggleListener('account', 'dropdown-menu', 'active');
});
