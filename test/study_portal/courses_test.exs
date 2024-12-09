defmodule StudyPortal.CoursesTest do
  use StudyPortal.DataCase

  alias StudyPortal.Courses

  describe "courses" do
    alias StudyPortal.Courses.Course

    import StudyPortal.CoursesFixtures

    @invalid_attrs %{course_code: nil, course_name: nil, files: nil, department: nil}

    test "list_courses/0 returns all courses" do
      course = course_fixture()
      assert Courses.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id" do
      course = course_fixture()
      assert Courses.get_course!(course.id) == course
    end

    test "create_course/1 with valid data creates a course" do
      valid_attrs = %{course_code: "some course_code", course_name: "some course_name", files: "some files", department: "some department"}

      assert {:ok, %Course{} = course} = Courses.create_course(valid_attrs)
      assert course.course_code == "some course_code"
      assert course.course_name == "some course_name"
      assert course.files == "some files"
      assert course.department == "some department"
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course(@invalid_attrs)
    end

    test "update_course/2 with valid data updates the course" do
      course = course_fixture()
      update_attrs = %{course_code: "some updated course_code", course_name: "some updated course_name", files: "some updated files", department: "some updated department"}

      assert {:ok, %Course{} = course} = Courses.update_course(course, update_attrs)
      assert course.course_code == "some updated course_code"
      assert course.course_name == "some updated course_name"
      assert course.files == "some updated files"
      assert course.department == "some updated department"
    end

    test "update_course/2 with invalid data returns error changeset" do
      course = course_fixture()
      assert {:error, %Ecto.Changeset{}} = Courses.update_course(course, @invalid_attrs)
      assert course == Courses.get_course!(course.id)
    end

    test "delete_course/1 deletes the course" do
      course = course_fixture()
      assert {:ok, %Course{}} = Courses.delete_course(course)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_course!(course.id) end
    end

    test "change_course/1 returns a course changeset" do
      course = course_fixture()
      assert %Ecto.Changeset{} = Courses.change_course(course)
    end
  end
end
