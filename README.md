# todoListApp

`todoListApp`은 기본적인 할 일 관리 앱입니다. 사용자는 할 일을 추가, 삭제, 수정할 수 있으며, '오전'과 '오후'로 할 일을 구분하여 관리할 수 있습니다.

## MVC 구조를 활용한 설계

### 1. Model:
- **TaskManager**: 주요 데이터 관리 클래스. `CoreData`를 사용하여 할 일과 완료한 일을 저장, 로드, 수정, 삭제하는 기능을 제공합니다.

### 2. Controller:
- **MainViewController**: 메인 페이지 입니다. 버튼을 통해 "할 일", "한 일", "프로필 페이지"로 이동 할 수 있습니다.
- **TodoPageViewController**: 버튼을 이용해서 셀을 추가, "할 일"들을 추가 하고 스위치를 눌러 "한 일"로 넘길 수 있습니다.
- **DonePageViewController**: "할 일" 페이지에서 완료한 항목들이 보여지는 페이지 입니다. 수정을 통해 "할 일"로 보낼 수 있습니다.
- **ProfileDesignViewController**: 프로필 페이지 입니다. Grid 버튼을 통해서 사진 라이브러리로 셀에 사진을 넣을 수 있습니다. 

### 3. ViewMode:
- **MainViewController**: 메인 페이지에서 보여지는 고양이 사진을 불러오는 로직이 있습니다.
- **TodoPageViewController**: "할 일"의 셀의 CRUD 메서드가 있습니다
- **DonePageViewController**: "한 일"의 RUD 메서드가 있습니다. 참고 : C 즉 추가는 "할 일" 페이지에서만 가능 합니다. 
- **ProfileDesignViewController**: 사진들을 불러와서 띄우는 함수들이 있습니다.
- 
## 설명
`todoListApp`은 MVVM 디자인 패턴을 기반으로 설계되었습니다. Model은 데이터와 관련된 로직을, View는 사용자 인터페이스와 관련된 로직을, ViewModel은 View에서 보여지게 하는 함수와 로직들이 있습니다. 이 앱에서 사용자는 할 일을 추가할 때 오전 또는 오후로 구분하여 저장할 수 있습니다. 또한 사용자는 할 일을 선택하여 수정하거나 스와이프하여 삭제할 수 있습니다. URL에서 가져온 고양이 이미지와 스파르타 이미지는 스켈레톤 이미지를 대신해서 스파르타 이미지를 띄우고, 조금의 딜레이를 주고 고양이 이미지를 띄우도록 만들었습니다.

## 마치며
MVVM 패턴의 활용으로 앱의 각 구성 요소간의 역할이 명확하게 구분되었습니다. 이 구조는 코드의 유지 보수와 확장성을 향상시켰습니다.
