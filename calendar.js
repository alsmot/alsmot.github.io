document.addEventListener('DOMContentLoaded', function () {
    const calendarElement = document.querySelector('.calendar-days');
    const currentDate = new Date();
    let currentMonth = currentDate.getMonth();
    let currentYear = currentDate.getFullYear();

    const monthNames = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
    ];

    //生成當月的日期
    function generateCalendar(year, month) {
        calendarElement.innerHTML = '';
        const firstDay = new Date(year, month, 1).getDay();
        const lastDay = new Date(year, month + 1, 0).getDate();
        const todos = loadTodos();

        
        let dateRow = document.createElement('div');
        dateRow.classList.add('row', 'g-0',);

        // 每個月1號以前的格子
        for (let i = 0; i < firstDay; i++) {
            const beforeday = document.createElement('div');
            beforeday.classList.add('col', 'calendar-day', 'border', 'border-dark');
            dateRow.appendChild(beforeday);
        }

        // 這個月的格子
        for (let day = 1; day <= lastDay; day++) {
            if (dateRow.children.length === 7) {
                calendarElement.appendChild(dateRow);
                dateRow = document.createElement('div');
                dateRow.classList.add('row', 'g-0');
            }

            //生成每一天
            const mainday = document.createElement('div');
            mainday.classList.add('col', 'calendar-day', 'border', 'border-dark');

            //往每一天裡面加日期
            const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
            mainday.innerHTML = `<div class="calendar-day-number">${day}</div>`

            //把今天標示出來
            if (year === currentDate.getFullYear() && month === currentDate.getMonth() && day === currentDate.getDate()) {
                mainday.classList.add('bg-primary', 'text-white');
            }

            // 新增事件
            if (todos[dateStr]) {
                todos[dateStr].forEach((todo, index) => {
                    mainday.innerHTML += `
                        <div class="todo-item">
                            <small>${todo.text}</small>
                            <button class="btn btn-danger btn-sm delete-btn" data-date="${dateStr}" data-id="${index}">Delete</button> 
                        </div>`; //要設定data-set與data-id才能夠抓到是哪一天的第幾項去刪除
                });
            }

            mainday.addEventListener('click', function () {
                // 這裡你可以處理顯示待辦事項的邏輯
                const todoDateInput = document.getElementById('todoDate');
                todoDateInput.value = dateStr;
                document.getElementById('todoText').value = '';
                document.getElementById('todoId').value = '';
                document.getElementById('saveBtn').style.display = 'block';
                document.getElementById('deleteBtn').style.display = 'none';
                const modal = new bootstrap.Modal(document.getElementById('todolist'));
                modal.show();
            });

            dateRow.appendChild(mainday);
        }

        // 把剩餘的格子補滿7天
        while (dateRow.children.length < 7) {
            const remainday = document.createElement('div');
            remainday.classList.add('col', 'calendar-day', 'border', 'border-dark');
            dateRow.appendChild(remainday);
        }

        calendarElement.appendChild(dateRow);
    }

    //更新header月份
    function updateHeader(year, month) {
        document.querySelector('.chooseYear').innerText = monthNames[month];
        document.querySelector('.chooseMonth').innerText = year;
    }

    //設定上個月按鈕
    const lastBtn = document.querySelector('.last_Btn')
    lastBtn.addEventListener('click', function () {
        if (currentMonth === 0) {
            currentMonth = 11;
            currentYear--;//已經是1月就要變成去年
        } else {
            currentMonth--;
        }
        generateCalendar(currentYear, currentMonth);
        updateHeader(currentYear, currentMonth);
    });

    //設定下個月按鈕
    const nextBtn = document.querySelector('.next_Btn')
    nextBtn.addEventListener('click', function () {
        if (currentMonth === 11) {
            currentMonth = 0;
            currentYear++;
        } else {
            currentMonth++;
        }
        generateCalendar(currentYear, currentMonth);
        updateHeader(currentYear, currentMonth);
    });

    //設定跳回今天的按鈕
    const todayBtn = document.querySelector('.today_Btn')
    todayBtn.addEventListener('click', function () {
        currentMonth = currentDate.getMonth();
        currentYear = currentDate.getFullYear();
        generateCalendar(currentYear, currentMonth);
        updateHeader(currentYear, currentMonth);
    });

    const todoForm = document.getElementById('todoForm');
    todoForm.addEventListener('submit', function (event) {
        event.preventDefault();
        const date = document.getElementById('todoDate').value;
        const text = document.getElementById('todoText').value;
        const id = document.getElementById('todoId').value;
        const todos = loadTodos();

        if (!todos[date]) {
            todos[date] = [];
        }

        if (id) {
            todos[date][id].text = text;
        } else {
            todos[date].push({ text });
        }

        saveTodos(todos);
        generateCalendar(currentYear, currentMonth);
        document.getElementById('todoForm').reset();
        const modal = bootstrap.Modal.getInstance(document.getElementById('todolist'));
        modal.hide();
    });

    document.querySelector('.calendar-days').addEventListener('click', function (event) {
        if (event.target.classList.contains('delete-btn')) {
                const date = event.target.dataset.date;
                const index = event.target.dataset.id;
                const todos = loadTodos();

                todos[date].splice(index, 1); //刪除index位置1個
                if (todos[date].length === 0) { 
                    delete todos[date]; //如果不刪除key會一直累積
                }

                saveTodos(todos);
                generateCalendar(currentYear, currentMonth);

        }
    });

    function loadTodos() {
        return JSON.parse(localStorage.getItem('todos')) || {}; //將json轉成字串讀取
    }

    function saveTodos(todos) {
        localStorage.setItem('todos', JSON.stringify(todos)); //轉成json檔儲存
    }


    generateCalendar(currentYear, currentMonth);
    updateHeader(currentYear, currentMonth);
});

