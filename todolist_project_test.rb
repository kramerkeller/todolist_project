Launch logo dark background
MENU
Courses
Forum (8)
Events (3)
Sharing (2)
Resources
Exercises
Pages
Back
Our Pedagogy
Mastery-based Learning
Results & Outcomes
For Employers
Is This For Me
Common Questions
The Student Experience
Core Curriculum
Capstone
Chat Room
My Account
My Assessments
Sign Out

Courses130 Ruby Foundations: More TopicsLesson 3: Packaging Code Into a ProjectSetting Up The Project Directory
Setting Up The Project Directory
The first step for a new Ruby project is to set up your working directory. The name of this directory is unimportant so long as you can find it easily. However, since some tools have trouble with some directory names, you should restrict the name to just letters, digits, and underscores. Specifically, avoid using spaces in the directory name, or in any of its parent or grandparent directories. This is important: you can see some very strange bugs if there are spaces in any directory names.

We recommend that you create a brand-new directory for this lesson separate from your original todo list project. Make sure that none of the directory's parent directories are Git repositories. Your Ruby project should be a Git repo, but you may experience trouble if any parent or grandparent directory is also a git repo.

What is a Project?
We'll use the term project pretty loosely in this lesson. A project is simply a collection of one or more files used to develop, test, build, and distribute software. The software may be an executable program, a library module, or a combination of programs and library files. The project itself includes the source code (not only Ruby source code, but any language used by the project, such as JavaScript), tests, assets, HTML files, databases, configuration files, and more. While small projects include only a dozen or less files, major projects can include hundreds, even thousands, of files.

To aid developers moving from one project to another, most Ruby-based projects follow standard patterns: certain files and directories must be present, certain types of data are stored in certain locations, and some data must be presented in well-defined formats, etc. The most common standard for Ruby projects is the Rubygems standard. We won't explore the Rubygems standard in depth, but will stick to the standard in our example project. Later, you can read the Rubygems documentation to gain more in-depth knowledge.

Walkthrough: Setting Up Your Project
First create a remote repo on Github named todolist_project.git. Don't close your browser window after doing this, but leave it open at the Quick Setup page.

Next, create a directory on your local filesystem where you will do your work:

$ mkdir todolist_project
$ cd todolist_project
You can now run the commands from the "…or create a new repository on the command line" box on the Quick Setup page:

$ echo "# todolist_project" >> README.md
$ git init
$ git add README.md
$ git commit -m "Initial commit"
$ git remote add origin git@github.com:USERNAME/todolist_project.git
$ git push -u origin master
Copy and paste the following two files into your project directory.

todolist_project.rbShow
todolist_project_test.rbHide
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative 'todolist_project'

class TodoListTest < MiniTest::Test
  def setup
    @todo1 = Todo.new('Buy milk')
    @todo2 = Todo.new('Clean room')
    @todo3 = Todo.new('Go to gym')
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_add_raise_error
    assert_raises(TypeError) { @list.add(1) }
    assert_raises(TypeError) { @list.add('hi') }
  end

  def test_add_alias
    new_todo = Todo.new('Walk the dog')
    @list.add(new_todo)
    todos = @todos << new_todo

    assert_equal(todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    todo = @list.shift
    assert_equal(@todo1, todo)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    todo = @list.pop
    assert_equal(@todo3, todo)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done_question
    assert_equal(false, @list.done?)
  end

  def test_item_at
    assert_raises(IndexError) { @list.item_at(100) }
    assert_equal(@todo1, @list.item_at(0))
    assert_equal(@todo2, @list.item_at(1))
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(100) }
    @list.mark_done_at(1)
    assert_equal(false, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(100) }
    @todo1.done!
    @todo2.done!
    @todo3.done!

    @list.mark_undone_at(1)

    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end

  def test_done_bang
    @list.done!
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(100) }
    @list.remove_at(1)
    assert_equal([@todo1, @todo3], @list.to_a)
  end

  def test_to_s
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_2
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    OUTPUT

    @list.mark_done_at(1)
    assert_equal(output, @list.to_s)
  end

  def test_to_s_3
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    @list.done!
    assert_equal(output, @list.to_s)
  end

  def test_each
    result = []
    @list.each { |todo| result << todo }
    assert_equal([@todo1, @todo2, @todo3], result)
  end

  def test_each_returns_original_list
    assert_equal(@list, @list.each {|todo| nil })
  end

  def test_select
    @todo1.done!
    list = TodoList.new(@list.title)
    list.add(@todo1)

    assert_equal(list.title, @list.title)
    assert_equal(list.to_s, @list.select{ |todo| todo.done? }.to_s)
  end
end
Typically, ruby projects have a strict organization. Specifically, developers expect to find test code in a test directory, and Ruby source files in the lib directory. Go ahead and create these two directories, and store each of the downloaded files in the proper directory:

$ mkdir lib test
$ mv todolist_project.rb lib
$ mv todolist_project_test.rb test
You may remember that todolist_project_test.rb has a require_relative statement to load the main program, todolist_project.rb. With the new directory structure, you must change that statement to load todolist_project.rb from its new location. Open test/todolist_project_test.rb and replace the require_relative with:

require_relative '../lib/todolist_project'
Save the file. require_relative loads files relative to the location of the original file. Since lib and test are both inside the main project directory, we tell require_relative to move up one level (the ..), then down inside lib, and finally to load todolist_project.rb.

You now have the basic structure of a typical ruby project. There are many other directories that you may need. For instance, web-based programs generally require "assets" like images, JavaScript, and CSS (stylesheets) -- these often reside in an assets directory with a subdirectory for each file type: images, javascript, and stylesheets. HTML "template" files usually reside in a views directory. You will see these different types of files in later courses, and will organize your projects in the way most Ruby developers organize things.

This simple project requires only the lib and test directories, so you're done structuring things. Feel free to commit and push your updates.

Our current project file structure should look like this:

todolist_project
├── README.md
├── lib
│   └── todolist_project.rb
└── test
    └── todolist_project_test.rb
 The Ruby Toolbox
