#Presentations
*Norfolk Data Science (NDS)*

-------

A repository of presentations made at Norfolk Data Science meetings

###Viewing the Presentations

Go to the homepage and click away! https://norfolkdatasci.github.io/presentations/

###Contributing Your Presentation

1. Clone this repository (`git clone git@github.com:norfolkdatasci/presentations.git`)
2. Make a branch for your presentation from the master branch
	1. `git checkout -b my_presentation`
	2. `git push -u origin my_presentation` 
3. Copy another presentation folder and change the name to the name of your presentation
    1. Use only lowercase letters, numbers and hypens in your folder name
    2. Try to use a more recent presentation when you copy. Typically, more formatting
    and styling tricks are added over time and the newest presentations will have the
    nicest looking content.
4. Add your content. See instructions below for how to add different content types (PPTX, PDF, HTML, RPres)    
5. When you are ready submit a pull request to the `master` branch

###How to Add Different Content Types (PPTX, PDF, HTML, RPres)  

####Powerpoint
If you are making powerpoint slides, save them to the repository when you are totally finished. 
We don't need to see your incremental changes as different commits since this is not a plain text format. Also, 
upload a copy of the slides as PDF. The PDF slides will render nicely within GitHub and other places.

####PDF
Save the to the repository when you are totally finished. We don't need to see your incremental changes
as different commits since this is not a plain text format.

####RPres
Start working on your Rpres file by updating the metatags in the top of the document that you copied (index.Rpres). 
Then start adding your content through a combination of markdown and HTML. When you're ready, just click "Save as Web Page"
within RStudio and this will save your slides as index.html. This allows viewers to go straight to the repo and see your 
slides rendered right in the browser.

####HTML
Start working on your html-based presentation. Commit and finish however you like, we only ask that you save it as index.html. 
This allows viewers to go straight to the repo and see your slides rendered right in the browser.
