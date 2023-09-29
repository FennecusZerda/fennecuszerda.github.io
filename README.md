# Noah's Portfolio Website

## Structure

-   pages
    -   This is where each page on your site lives. Each page is represented by a `[name].html` file.
-   images
    -   This is where all images loaded into pages live. To load images into a paage, make sure a folder exists in this folder with exactly the same name as the page. Eg, for a page named `homeboy.html`, create a folder named `homeboy` _case sensitive_.

You don't need to worry about any of the other folders.

> ⚠️ the `index` page is the "root" or "home" page for your website. Do _not_ delete it.

## Creating a Page

To create a new page there's 3 steps:

-   In the pages folder:
    -   Create a new file with the name of your page (no spaces) with a `.html` extension.
-   In the images folder:
    -   Create a folder with the same name (case sensitive, again no spaces, and no html extension).
-   Add the page to your navigation bar:
    -   Yell at Khan once you've created the new file, uploaded all your images, and are ready to deploy the new page (it'll take him like 2 seconds).

Say we're creating a new page called `sports`, at the end of these steps you should have:

```
pages/
	sports.html
images/
	sports/
		... all images
```

> The name of this file is not important. It will be the URL you link to (eg, http://noahmcgrew/sports.html), but will not appear anywhere in the UI. The requirements for the name of the file are:
>
> -   No spaces
> -   Use `camel_case`
> -   No slashes

## Formatting a Page

### Content

There are a _lot_ of options for what you can put in a page. You can embed any HTML you want, so for text I suggest writing a page in markdown and using a converter like [this one](https://markdowntohtml.com/) to convert it to HTML.

To add that generated HTML to the page, add the following:

```html
<div class="content">
	<!-- Paste the markdown HTML here -->
</div>
```

### Images

There are two ways to embed images in your site.

1. Use a carosel (this is the best one)

You can add an image carosel by adding the following to your page file: `{{images}}`.
This will create a carosel with _every_ image in the images/pagename folder.

If you want to have more than one carosel in your page, you can add subfolders to your page's image folder.
For instance say I want two carosels in my `sports` page, one for `baseball` and one for `basketball`. You can create a folder of images for each carosel like so:

```
images/
	sports/
		baseball/
		basketball/
```

You can then embed all the images in either folder like so:

```html
{{images.baseball}}
<!-- Carosel with all the baseball images -->
{{images.basketball}}
<!-- Carosel with all the basketball images -->
```

This is supported for more than one level of depth too so if you want to get really organized you could do something like:

```html
{{images.baseball.nov-10-2023.morning}}
```

Where you have a folder structure like:

```
images/
	sports/
		baseball/
			nov-10-2023/
				morning/
					... Images
```

2. Add a single image

You can also embed a single image like so:

```html
{{image.my-cool-image.jpg}}
```

This image can be in _any_ sub folder in the same images folder. So, if you don't want a carosel to include the image add it to it's own folder like:

```
images/
	sports/
		solo_images/my-cool-image.jpg <- Will not be on any carosels
		baseball/ <- All the baseball carosel images
```
