#!/bin/bash

# Student Management System (SMS) - Bash Implementation

DATA_FILE="students.txt"
TEACHER_CREDENTIALS="teacher_login.txt"
STUDENT_CREDENTIALS="student_login.txt"
CGPA_THRESHOLD=2.0

# Initialize Data Files
if [ ! -f "$DATA_FILE" ]; then
    touch "$DATA_FILE"
fi
if [ ! -f "$TEACHER_CREDENTIALS" ]; then
    echo "teacher:password" > "$TEACHER_CREDENTIALS"
fi
if [ ! -f "$STUDENT_CREDENTIALS" ]; then
    touch "$STUDENT_CREDENTIALS"
fi

# Function to Display Main Menu
main_menu() {
    while true; do
        echo "================================="
        echo "   Welcome to Student Management System   "
        echo "================================="
        echo "1. Teacher Login"
        echo "2. Student Login"
        echo "3. Exit"
        echo "================================="
        read -p "Enter your choice: " choice
        case $choice in
            1) authenticate_teacher ;;
            2) authenticate_student ;;
            3) exit 0 ;;
            *) echo "Invalid choice! Please try again." ;;
        esac
    done
}

# Function to Authenticate Teacher
authenticate_teacher() {
    echo "Enter Teacher Username:"
    read username
    echo "Enter Password:"
    read -s password
    if grep -q "^$username:$password" "$TEACHER_CREDENTIALS"; then
        echo "Teacher Login Successful"
        teacher_menu
    else
        echo "Invalid credentials! Please try again."
    fi
}

# Function to Authenticate Student
authenticate_student() {
    echo "Enter Student Roll Number:"
    read roll_no
    if grep -q "^$roll_no," "$DATA_FILE"; then
        echo "Student Login Successful"
        student_menu "$roll_no"
    else
        echo "Invalid Roll Number! Please try again."
    fi
}

# Function to Add Student
add_student() {
    echo "Enter Roll Number:"
    read roll_no
    echo "Enter Name:"
    read name
    echo "Enter Total Marks:"
    read total_marks
    cgpa=$(echo "scale=4; $total_marks / 25" | bc)  # CGPA formatted to 4 decimal places
    grade="F"

    if [ "$total_marks" -ge 90 ]; then grade="A+"
    elif [ "$total_marks" -ge 80 ]; then grade="A"
    elif [ "$total_marks" -ge 70 ]; then grade="B"
    elif [ "$total_marks" -ge 60 ]; then grade="C"
    elif [ "$total_marks" -ge 50 ]; then grade="D"
    fi

    echo "$roll_no,$name,$total_marks,$cgpa,$grade" >> "$DATA_FILE"
    echo "Student added successfully!"
}

# Function to View Student Details in Proper Format
view_student() {
    echo "Enter Roll Number:"
    read roll_no
    student_info=$(grep "^$roll_no," "$DATA_FILE")

    if [ -z "$student_info" ]; then
        echo "Student not found."
        return
    fi

    echo "===================================="
    echo "| Roll No   | Name         | Marks | CGPA   | Grade |"
    echo "------------------------------------"
    echo "$student_info" | awk -F',' '{
        printf "| %-9s | %-11s | %-5s | %-6s | %-5s |\n", $1, $2, $3, $4, $5;
    }'
    echo "===================================="
}

# Function to Delete Student
delete_student() {
    echo "Enter Roll Number:"
    read roll_no
    grep -v "^$roll_no," "$DATA_FILE" > temp.txt && mv temp.txt "$DATA_FILE"
    echo "Student deleted successfully!"
}

# Function to Assign Marks
assign_marks() {
    echo "Enter Roll Number:"
    read roll_no
    echo "Enter New Marks:"
    read marks
    cgpa=$(echo "scale=4; $marks / 25" | bc)
    grade="F"

    if [ "$marks" -ge 90 ]; then grade="A+"
    elif [ "$marks" -ge 80 ]; then grade="A"
    elif [ "$marks" -ge 70 ]; then grade="B"
    elif [ "$marks" -ge 60 ]; then grade="C"
    elif [ "$marks" -ge 50 ]; then grade="D"
    fi

    awk -v roll="$roll_no" -v new_marks="$marks" -v new_cgpa="$cgpa" -v new_grade="$grade" 'BEGIN{FS=OFS=","} $1==roll{$3=new_marks;$4=new_cgpa;$5=new_grade} 1' "$DATA_FILE" > temp.txt && mv temp.txt "$DATA_FILE"
    echo "Marks updated successfully!"
}

# Function to Calculate Grades
calculate_grades() {
    awk -F',' 'BEGIN {OFS=","} 
    {
        grade = "F";  
        if ($3 >= 90) grade = "A+"; 
        else if ($3 >= 80) grade = "A"; 
        else if ($3 >= 70) grade = "B"; 
        else if ($3 >= 60) grade = "C"; 
        else if ($3 >= 50) grade = "D"; 
        $4 = sprintf("%.4f", $3 / 25);
        print $1, $2, $3, $4, grade;
    }' "$DATA_FILE" > temp.txt && mv temp.txt "$DATA_FILE"

    echo "Grades calculated successfully!"
}

# Function to Sort Students by CGPA
sort_students() {
    echo "1. Ascending Order"
    echo "2. Descending Order"
    read -p "Enter choice: " choice
    if [ "$choice" -eq 1 ]; then
        sort -t',' -k4,4n "$DATA_FILE"
    else
        sort -t',' -k4,4nr "$DATA_FILE"
    fi
}

# Function to List Passed & Failed Students
list_pass_fail() {
    echo "1. List Passed Students"
    echo "2. List Failed Students"
    read -p "Enter choice: " choice
    if [ "$choice" -eq 1 ]; then
        awk -F',' -v threshold="$CGPA_THRESHOLD" '$4 >= threshold' "$DATA_FILE"
    else
        awk -F',' -v threshold="$CGPA_THRESHOLD" '$4 < threshold' "$DATA_FILE"
    fi
}

# Teacher Menu
teacher_menu() {
    while true; do
        echo "===================="
        echo " Teacher Menu "
        echo "===================="
        echo "1. Add Student"
        echo "2. View Student"
        echo "3. Delete Student"
        echo "4. Assign Marks"
        echo "5. Calculate Grades"
        echo "6. Sort Students by CGPA"
        echo "7. List Passed/Failed Students"
        echo "8. Logout"
        read -p "Enter choice: " choice
        case $choice in
            1) add_student ;;
            2) view_student ;;
            3) delete_student ;;
            4) assign_marks ;;
            5) calculate_grades ;;
            6) sort_students ;;
            7) list_pass_fail ;;
            8) main_menu ;;
            *) echo "Invalid choice!" ;;
        esac
    done
}

# Student Menu
student_menu() {
    while true; do
        echo "===================="
        echo " Student Menu "
        echo "===================="
        echo "1. View Grades"
        echo "2. View CGPA"
        echo "3. Logout"
        read -p "Enter choice: " choice
        case $choice in
            1) view_student ;;
            2) awk -F',' -v student="$1" '$1 == student {print "CGPA:", $4}' "$DATA_FILE" ;;
            3) main_menu ;;
            *) echo "Invalid choice!" ;;
        esac
    done
}

# Start the system
main_menu

