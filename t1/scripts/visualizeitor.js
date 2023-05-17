const STUDENTS_DATA_PATH = "/data/students-data.json";
const STUDENTS = [];

function buildStudent(studentData) {
  return {
    id: studentData["ID_CURSO_ALUNO"],
    name: studentData["NOME_ALUNO"],
    student_code: studentData["MATR_ALUNO"],
    course_name: studentData["NOME_CURSO"],
    subjects: {},
  };
}

function addSubjectToStudent(student, studentData) {
  const subject = {
    subject_name: studentData["NOME_ATIV_CURRIC"],
    subject_code: studentData["COD_ATIV_CURRIC"],
    status: studentData["SITUACAO"],
    student_frequency: studentData["FREQUENCIA"],
    subject_type: studentData["DESCR_ESTRUTURA"],
    amount_hours: studentData["CH_TOTAL"],
    semester: studentData["PERIODO"],
    student_grade: studentData["MEDIA_FINAL"],
    year: studentData["ANO"],
  };

  if (!student.subjects.hasOwnProperty(subject["subject_code"])) {
    student.subjects[subject["subject_code"]] = {
      name: subject["subject_name"],
      type: subject["subject_type"],
      amount_hours: subject["amount_hours"],
      history: [
        {
          status: subject["status"],
          frequency: subject["student_frequency"],
          grade: subject["student_grade"],
          semester_coursed: subject["semester"],
          year_coursed: subject["year"],
        },
      ],
    };

    return;
  }

  student.subjects[subject["subject_code"]].history.push({
    status: subject["status"],
    frequency: subject["student_frequency"],
    grade: subject["student_grade"],
    semester_coursed: subject["semester"],
    year_coursed: subject["year"],
  });
}

function getStudentsData() {
  const xmlHttp = new XMLHttpRequest();

  xmlHttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      const response = xmlHttp.responseText;
      const data = JSON.parse(response);

      handleData(data);
    }
  };

  xmlHttp.open("GET", STUDENTS_DATA_PATH, true);
  xmlHttp.send();
}

function handleData(data) {
  const studentsData = data.data.students;

  studentsData.forEach((studentData) => {
    let currentStudent = STUDENTS.find(
      (student) => student["student_code"] == studentData["MATR_ALUNO"]
    );

    if (!currentStudent) {
      currentStudent = buildStudent(studentData);

      STUDENTS.push(currentStudent);
    }

    addSubjectToStudent(currentStudent, studentData);
  });
}

getStudentsData();
console.log(STUDENTS);
