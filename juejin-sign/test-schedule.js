const { scheduleJob } = require('node-schedule');
const { exec } = require('child_process');

// 生成一个随机整数，范围在min和max之间（包括min和max）
function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

// 生成随机执行时间
function generateRandomExecutionTime() {
    const randomHour = getRandomInt(0, 23);
    const randomMinute = getRandomInt(0, 59);
    return { hour: randomHour, minute: randomMinute };
}

// 执行任务
function executeTask() {
    // 在这里执行你需要的文件或命令
    exec('node your_script.js', (error, stdout, stderr) => {
        if (error) {
            console.error(`执行出错: ${error}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
        console.error(`stderr: ${stderr}`);
    });
}

// 创建每天的午夜（0时0分）执行的定时任务
const job = scheduleJob('0 0 * * *', function() {
    // 生成随机执行时间
    const randomTime = generateRandomExecutionTime();
    const { hour, minute } = randomTime;

    console.log(`下次执行时间: ${hour}:${minute}`);

    // 执行任务
    executeTask();

    // 取消当前任务
    job.cancel();

    // 计算下次执行时间
    const nextExecutionTime = new Date();
    nextExecutionTime.setHours(hour);
    nextExecutionTime.setMinutes(minute);
    nextExecutionTime.setSeconds(0);

    // 如果下次执行时间在当前时间之前，将其推迟到明天
    if (nextExecutionTime <= Date.now()) {
        nextExecutionTime.setDate(nextExecutionTime.getDate() + 1);
    }

    // 为下次任务安排定时任务
    job.reschedule(nextExecutionTime);
});

// 如果需要手动停止定时任务，可以调用 job.cancel() 方法
// job.cancel();