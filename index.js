function startSlideshow(container) {
	container.setAttribute("data-index", "0");
	container.children[0].setAttribute("data-active", "true");
}

function moveSlides(element, direction) {
	let container = element.parentElement;
	let images = container.getElementsByClassName("image");
	let currentIndex = parseInt(container.getAttribute("data-index"));
	let nextIndex = currentIndex + direction;
	if (nextIndex < 0) {
		nextIndex = images.length - 1;
	} else if (nextIndex > images.length - 1) {
		nextIndex = 0;
	}
	container.children[currentIndex].setAttribute("data-active", "false");
	container.children[nextIndex].setAttribute("data-active", "true");
	container.setAttribute("data-index", nextIndex);
}

window.moveSlides = moveSlides;

document.addEventListener("DOMContentLoaded", () => {
	// Get all "navbar-burger" elements
	const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll(".navbar-burger"), 0);

	// Add a click event on each of them
	$navbarBurgers.forEach((el) => {
		el.addEventListener("click", () => {
			console.log("here!!!");
			// Get the target from the "data-target" attribute
			const target = el.dataset.target;
			const $target = document.getElementById(target);

			// Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
			el.classList.toggle("is-active");
			$target.classList.toggle("is-active");
		});
	});

	document.getElementsByClassName("image-container").forEach((container) => {
		startSlideshow(container);
	});

	document.getElementsByClassName("image-container-dynamic").forEach((container) => {
		startSlideshow(container);
	});
});
