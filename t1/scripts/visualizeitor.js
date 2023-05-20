const STUDENTS_DATA_PATH = "/data/students-data.json";
const STUDENTS = [];
const SUBJECTS = [
  "CI068",
  "CI210",
  "CI212",
  "CI215",
  "CI162",
  "CI163",
  "CI221",
  "OPT",
  "CI055",
  "CI056",
  "CI057",
  "CI062",
  "CI065",
  "CI165",
  "CI211",
  "OPT",
  "CM046",
  "CI067",
  "CI064",
  "CE003",
  "CI059",
  "CI209",
  "OPT",
  "OPT",
  "CM045",
  "CM005",
  "CI237",
  "CI058",
  "CI061",
  "CI218",
  "OPT",
  "OPT",
  "CM201",
  "CM202",
  "CI166",
  "CI164",
  "SA214",
  "CI220",
  "TG I",
  "TG II",
];

let selectedStudent;

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

async function getStudentsData() {
  return new Promise((resolve, reject) => {
    const xmlHttp = new XMLHttpRequest();

    xmlHttp.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          const response = xmlHttp.responseText;
          const data = JSON.parse(response);

          handleData(data);

          resolve();
        } else {
          reject(new Error("Failed to fetch students' data"));
        }
      }
    };

    xmlHttp.open("GET", STUDENTS_DATA_PATH, true);
    xmlHttp.send();
  });
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

function fillStudentsSelect() {
  const studentsInput = document.querySelector("#students");
  let options = "";

  STUDENTS.forEach((student) => {
    options += `<option value="${student.student_code}">
                  ${student.name} - ${student.student_code}
                </option>`;
  });

  studentsInput.innerHTML = options;
}

function getCellBackgroundColor(subjectHistory) {
  if (!subjectHistory) return null;

  const lastTimeCoursed = subjectHistory[subjectHistory.length - 1];

  let backgroundColor;

  switch (lastTimeCoursed["status"]) {
    case "Aprovado":
    case "Dispensa de Disciplinas (com nota)":
      backgroundColor = "green";
      break;
    case "Equivalência de Disciplina":
      backgroundColor = "orange";
      break;
    case "Reprovado por nota":
    case "Reprovado por Frequência":
    case "Cancelado":
    case "Trancamento Administrativo":
    case "Trancamento Total":
      backgroundColor = "red";
      break;
    case "Matrícula":
      backgroundColor = "blue";
      break;
    default:
      backgroundColor = null;
      break;
  }

  return backgroundColor;
}

function getOpts() {
  const studentSubjects = selectedStudent.subjects;
  const allStudentOpts = [];

  for (let subjectCode in studentSubjects)
    if (studentSubjects[subjectCode]["type"] == "Optativas")
      allStudentOpts.push(subjectCode);

  return allStudentOpts;
}

function getTgs() {
  const studentSubjects = selectedStudent.subjects;
  const allStudentTgs = {
    tg1: [],
    tg2: [],
  };

  for (let subjectCode in studentSubjects) {
    if (studentSubjects[subjectCode]["type"] == "Trabalho de Graduação I")
      allStudentTgs["tg1"].push(subjectCode);
    else if (studentSubjects[subjectCode]["type"] == "Trabalho de Graduação II")
      allStudentTgs["tg2"].push(subjectCode);
  }

  return allStudentTgs;
}

function updateTable() {
  const tbody = document.querySelector("#table-body");
  const opts = getOpts();
  const tgs = getTgs();

  let tableBodyContent = "";

  for (let index = 0; index < SUBJECTS.length; index += 8) {
    tableBodyContent += "<tr>";
    for (let i = 0; i < 8; i++) {
      const currentSubject = SUBJECTS[index + i];
      let actualCurrentSubject;

      if (currentSubject === "OPT") {
        let optCode;

        if (opts.length > 0) {
          optCode = opts.pop();
        } else optCode = "OPT";

        actualCurrentSubject = optCode;
      } else if (currentSubject === "TG I") {
        let tg1Code;

        if (tgs["tg1"].length > 0) {
          tg1Code = tgs["tg1"].pop();
        } else tg1Code = "TG I";

        actualCurrentSubject = tg1Code;
      } else if (currentSubject === "TG II") {
        let tg2Code;

        if (tgs["tg2"].length > 0) {
          tg2Code = tgs["tg2"].pop();
        } else tg2Code = "TG II";

        actualCurrentSubject = tg2Code;
      } else actualCurrentSubject = currentSubject;

      const subjectHistory =
        selectedStudent.subjects[actualCurrentSubject]?.["history"];
      const backgroundColor = getCellBackgroundColor(subjectHistory);

      tableBodyContent += `
                          <td
                            ${
                              backgroundColor
                                ? `style="background-color: ${backgroundColor};"`
                                : ""
                            }
                            oncontextmenu="handleRightClick(event, '${actualCurrentSubject}')"
                            onclick="handleLeftClick(event, '${actualCurrentSubject}')">
                          ${actualCurrentSubject}
                          </td>`;
    }
    tableBodyContent += "</tr>";
  }

  tbody.innerHTML = tableBodyContent;
}

function handleStudentChanged(studentGrr) {
  selectedStudent = STUDENTS.find(
    (student) => student["student_code"] == studentGrr
  );

  updateTable();
}

function handleLeftClick(event, subject_code) {
  event.preventDefault();

  const subjectHistoryHtmlTag = document.querySelector("#subject-history");
  const subjectStudied = selectedStudent.subjects[subject_code];

  let subjectHistoryHtmlTagContent = "";

  if (!subjectStudied) {
    subjectHistoryHtmlTagContent += `<h2>Não há histórico do aluno para a matéria de código: ${subject_code}</h2>`;
  } else {
    subjectHistoryHtmlTagContent += `<h2>Histórico de ${subjectStudied["name"]}(${subject_code}) - ${subjectStudied["type"]}</h2>`;

    subjectStudied["history"].forEach((subjectHistory, index) => {
      subjectHistoryHtmlTagContent += `
                                      <div>
                                        <div>${index + 1}° vez</div>
                                        <div>Ano: ${
                                          subjectHistory["year_coursed"]
                                        }</div>
                                        <div>Semestre: ${
                                          subjectHistory["semester_coursed"]
                                        }</div>
                                        <div>Nota final: ${
                                          subjectHistory["grade"]
                                        }</div>
                                        <div>Frequência: ${
                                          subjectHistory["frequency"]
                                        }</div>
                                        <div>Situação: ${
                                          subjectHistory["status"]
                                        }</div>
                                      </div>
                                      ${
                                        index !=
                                        subjectStudied["history"].length - 1
                                          ? '<div class="separator"></div>'
                                          : ""
                                      }
      `;
    });
  }

  subjectHistoryHtmlTag.innerHTML = subjectHistoryHtmlTagContent;
}

function handleRightClick(event, subject_code) {
  event.preventDefault();

  const subjectCoursed = selectedStudent.subjects[subject_code];

  if (!subjectCoursed) {
    alert(
      `${selectedStudent["name"]} - ${selectedStudent["student_code"]}\n
      Não há histórico do aluno para a matéria: ${subject_code}
      `
    );
  } else {
    const lastTimeCoursed =
      subjectCoursed["history"][subjectCoursed["history"].length - 1];

    alert(
      `${subject_code} - ${subjectCoursed["name"]}\n
      Ano: ${lastTimeCoursed["year_coursed"]}\n
      Semestre: ${lastTimeCoursed["semester_coursed"]}\n
      Nota final: ${lastTimeCoursed["grade"]}\n
      Frequência: ${lastTimeCoursed["frequency"]}\n
      Situação: ${lastTimeCoursed["status"]}\n
      `
    );
  }
}

getStudentsData()
  .then(() => {
    fillStudentsSelect();
    handleStudentChanged(STUDENTS[0]["student_code"]);
  })
  .catch((error) => {
    console.log(error);
  });
