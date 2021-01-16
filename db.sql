# 用户权限
--***********1、创建用户utest,密码为utest1************
CREATE USER utest
IDENTIFIED BY utest1;
--***********2、为utest用户赋予connect权和dba权************
grant connect,dba to utest;
--***********3、收回utest用户的dba权限************
revoke dba from utest;
--***********4、使用utest用户登录。（使用connect命令）。************
conn utest/utest1;
# 创建环境
--************1、创建Student表*********************
create table Student(
    Sno char(10) primary key,
    Sname varchar(20),
    Ssex char(2),
    Sage smallint,
    Sdept varchar(20)
);
--************2、创建Course表*********************
create table Course(
    Cno char(10) primary key,
    Cname varchar(20),
    Cpno char(10),
    Ccredit smallint
);
--************3、创建SC表*********************
create table SC(
    Sno char(10),
    Cno char(10),
    Grade smallint,
    CONSTRAINT PK_test PRIMARY KEY (Sno,Cno)
);
# 修改表结构
--************1、为course表添加一列snumber(最大选课人数)，类型为char(10)。*********************
alter table course add snumber char(10);
--************2、修改course表中snumber列，将其类型改为int。*********************
alter table course modify snumber int;
--************3、删除course表中的snumber列。*********************
alter table course drop (snumber);
# 删除表
--************1、删除student，course和sc表，其中sc表建立了外码（请注意删除顺序）*********************
drop table SC;
drop table student;
drop table course;
# DML增删改
--***********1、向Course表中插入一行************
insert into Course(cno,cname,ccredit,snumber) values('C50','Oracle',4,100);
--***********2、使用Insert语句为CS系学生学生选择必修课C50。************
insert into SC(Sno,Cno) select sno,'C50' from Student where sdept='CS';
--***********3、将Oracle课程的先行课修改为“DB”课程的课程号（使用子查询完成）************
update Course set cpno = (select cno from Course where cname = 'DB') where cname = 'Oracle';
--***********4、将CS系"DB"课程成绩为空的学生选课信息删除************
delete from SC where 
sno in(select sno from student where sdept ='CS') and 
Cno in (select cno from course where cname = 'DB') and
Grade is null;
# DML查询
--***********1、查询CS系年龄大于20岁的学生，列出学号，姓名，性别。************
select sno,sname,ssex from student where sage > 20 and sdept = 'CS';
--***********2、查询选了'DB'课程的学生的学号。************
select sno from sc where cno = (select cno from Course where cname = 'DB');
--***********3、查询CS系没有选'DB'课程的学生的学号，姓名，系。************
select sno,sname,sdept from student where sdept = 'CS' and sno not in (select sno from sc where cno =(select cno from course where cname='DB'));
--***********4、查询男同学选择了'DB'课程，但是没有选'Oracle'课程的学生，列出学号，姓名************
select sno,sname from student where ssex = 'm' 
    and sno in(select sno from sc 
        where cno =(select cno from course where cname = 'DB'))
    and sno not in(select sno from sc 
        where cno =(select cno from course where cname = 'Oracle'));
# DML查询统计
--***********1、查询每个学生的平均分，列出学生的学号，平均分（savg）,并按平均分降序排列。************
select sno,avg(grade) savg from sc group by sno order by avg(grade) desc;
--***********2、查询选课人数大于等于3人的课程，列出课程号，课程名，选课人数（scnt）,并按课程号升序排列。************
select course.cno,cname,count(sno) scnt from course,sc 
    where course.cno=sc.cno 
        group by course.cno,cname 
            having count(sno) >=3 
                order by course.cno asc;
--***********3、查询选课人数最多的课程。列出课程号，课程名。************
select cno,cname from course where cno = (select cno from sc group by cno having count(sno) >= all(select count(sno) from sc group by sno));
--***********4、查询CS系选课人数最多的课程。列出课程号，课程名，CS系的选课人数（CScnt）。************
select course.cno,cname,count(sno) CScnt from course,sc 
    where course.cno=sc.cno 
        and sno in (select sno from student where sdept = 'CS') 
    group by course.cno,cname 
    having count(sno) >= 
    all(select count(sno) from sc 
        where sno in (select sno from student 
            where sdept = 'CS') group by cno);
# PL/SQL匿名块1
--***********1、打印001号学生的姓名和年龄。*****************
declare
vname varchar(20);
vage smallint;
begin
    select sname,sage into vname,vage from student where sno ='001';
    dbms_output.put_line('001号同学的姓名：'||vname);
    dbms_output.put_line('001号同学的年龄：'||vage);
end;
--***********2、将年龄最大的同学的学号，姓名，年龄打印出来。***********
declare
vno char(10);
vname varchar(20);
vage smallint;
vsex char(2);
maxage smallint;
begin
select max(sage) into maxage from student;
select sno,sname,sage,ssex into vno,vname,vage,vsex from student where sage = maxage;
if vsex='f' then
    dbms_output.put_line(rtrim(vno)||','||vname||','||vage||','||'美女');
else
    dbms_output.put_line(rtrim(vno)||','||vname||','||vage||','||'帅哥');
end if;
end;
# PLSQL匿名块2
--***********1、将‘004’号同学的年龄改为18岁，系别改为‘E’，为CS系年龄最小的同学选‘C01’号课程。*****
declare
begin
    update student set sage = 18 , sdept = 'E' where sno = '004';
    insert into sc(sno,cno) select sno,'C01' 
    from student 
    where sdept = 'CS' and sage = (select min(sage) from student where sdept = 'CS') ;
    commit;
end;
--***********2、为‘002’号同学选‘C02’课程。将选课人数最多的课程的最大选课人数（snumber）改为105。*****
declare
maxcno char(10);
maxsno int;
begin
    insert into sc values('002','C02',null);
    update course set snumber = 105 
    where cno in (select cno from sc group by cno 
    having count(sno) = (select max(count(sno))  from sc group by cno));
    commit;
end;
# 异常处理
1、查询‘111’号同学的姓名，使用异常判断，若没有这个同学，则添加一条学号为‘111’的学生信息，姓名为‘张三’，其他属性为空，并输出：‘111’号同学已被成功添加。
       若存在该同学，则输出（冒号为中文状态下的冒号）：
           111号同学的姓名：查询出的姓名
       若不存在该同学，则输出：
           111号同学已被成功添加。
2、打印‘C50’号课程的当前选课人数和最大选课人数（Snumber）。若出现异常，则判断C50号课程是否存在，若不存在，则添加C50课程（’C50’,’NewCourse’,null,3,100），再让001号同学和003号同学选修C50号课程，成绩分别为80分和90分，最后打印C50号课程的当前选课人数和最大选课人数。打印格式如下：
    若C50存在，则打印格式如下（其中的逗号和冒号是中文状态下的）：
       （查询出的C50的课程名）课程当前选课人数：（查出来的人数），最大选课人数：（查出来的最大人数）
       如：DB课程当前选课人数：80，最大选课人数：100
    若C50不存在，则打印格式（其中的逗号和冒号是中文状态下的）：
       添加NewCourse课程成功，课程当前选课人数：（查出来的人数），最大选课人数：（查出来的最大人数）
       如：添加NewCourse课程成功，课程当前选课人数：10，最大选课人数：100
--***********1、异常处理第一题*****************
declare
vname varchar(20);
begin
select sname into vname from student where sno = '111';
dbms_output.put_line('111号同学的姓名：'||vname);
exception when no_data_found then 
    insert into student (sno,sname) values ('111','张三');
    dbms_output.put_line('111号同学已被成功添加。');
    commit;
end;
--***********2、异常处理第二题*****************
declare
currentnum int;
maxnum int;
vname varchar(20);
begin
select snumber,cname into maxnum,vname from course where cno ='C50';
select count(*) into currentnum from sc where cno ='C50' ;
dbms_output.put_line(vname||'课程当前选课人数：'||currentnum||'，最大选课人数：'||maxnum);
exception when no_data_found then
    insert into course values('C50','NewCourse',null,3,100);
    insert into sc values('001','C50',80);
    insert into sc values('003','C50',90);
    commit;
    select snumber,cname into maxnum,vname from course where cno ='C50';
    select count(*) into currentnum from sc where cno ='C50' ;
    dbms_output.put_line('添加NewCourse课程成功，课程当前选课人数：'||currentnum||'，最大选课人数：'||maxnum);
end;
# 异常处理之嵌套块
1、为English系年龄最大的同学选C52课程，并打印选课结果和该同学的选课数，若该生已经选择了C52课程，则打印该生的平均分。使用嵌套块中的异常判断，若没有English系，则将Student表中的E系修改为English系，并打印：已成功将E系修改为English系，然后退出程序。若没有C52课程，请添加C52课程（’C52’,’NC’,null,2,100）并打印：C52课程添加成功，然后退出程序。
注意：该程序要成功执行的前提是English系的最大年龄对应的同学只能有一个。若在你们自己的系统下测试，请通过修改数据确保这个前提条件。
测试规则：底层将通过调用四次程序，查看程序输出是否正确。
        （1）若学生和课程都存在，则为其选课，并输出（冒号为中文状态下的冒号）：
           已为（查询出的姓名）同学选择了课程（查询出来的课程名），该同学的选课门数为：（查询出的选课门数）
           如：已为张三同学选择了课程DB，该同学的选课门数为：10
        （2）若该生已经选择了课程C52，则输出：
          （查询出的姓名）同学的平均成绩为：（查询出的平均分）
          如：张三同学的平均成绩为：85
        （3）若系别不存在，则修改数据后，输出：
           已成功将E系修改为English系
        （4）若课程不存在，则添加数据后，输出：
           C52课程添加成功
--***********1、嵌套块异常处理第一题*****************
declare
    vsno char(10);
    vsname varchar(20);
    vcname varchar(20);
    num int;
    avggrade int;
begin
    select sno,sname into vsno,vsname from student where sage =(select max(sage) from student where sdept='English') and sdept = 'English';
    
    begin
        select cname into vcname from course where cno='C52';
        insert into sc values(vsno,'C52',null);
        select count(*) into num from sc where sno=vsno;
        commit;
        dbms_output.put_line('已为'||vsname||'同学选择了课程'||vcname||'，该同学的选课门数为：'||num);
        exception when no_data_found then 
                insert into course values('C52','NC',null,2,100);
                commit;
                dbms_output.put_line('C52课程添加成功');
            when dup_val_on_index then
                select avg(grade) into avggrade from sc where sno =vsno;
                dbms_output.put_line(vsname||'同学的平均成绩为：'||avggrade);
    end;

    exception when no_data_found then
        update student set sdept ='English' where sdept ='E';
        commit;
        dbms_output.put_line('已成功将E系修改为English系');
end;
# 游标
--***********1、使用静态游标，遍历所有选择了“数学”的学生，列出学生的学号，姓名，成绩（按学号升序排列）。*****************
declare
cursor c1 is select sc.sno,sname,grade from sc,student where sc.sno = student.sno and sdept ='CS' and cno = (select cno from course where cname ='数学') order by 1;
begin

    dbms_output.put_line(rpad('学号',10)||rpad('姓名',10)||'成绩');
    dbms_output.put_line(rpad('-',25,'-'));
    for i in c1 loop
    dbms_output.put_line(rpad(i.sno,10)||rpad(i.sname,10)||i.grade);
    end loop;

end;
--***********2、使用静态游标，遍历所有CS系学生的选课信息，打印学号，姓名，系别，课程名，成绩（按学号和课程名升序排列）。*****************
declare 
    cursor c1 is select sc.sno,sname,sdept,cname,grade from student,sc,course where student.sno=sc.sno and sc.cno=course.cno and sdept ='CS' order by 1,4;
    vsno char(10) :='001';
begin
    dbms_output.put_line(rpad('学号',10)||rpad('姓名',10)||rpad('系别',10)||rpad('课程名',10)||'成绩');
    dbms_output.put_line(rpad('=',45,'='));
    for i in c1 loop
    if vsno != i.sno then
        dbms_output.put_line(rpad('-',45,'-')); 
        vsno := i.sno;
    end if;
    dbms_output.put_line(rpad(i.sno,10)||rpad(i.sname,10)||rpad(i.sdept,10)||rpad(i.cname,10)||i.grade);
    end loop;
end;

# 动态游标
1、使用系统动态弱游标(sys_refcursor，请使用小写以便于后台验证)，查询男同学(性别为’m’)的选课情况，将每个同学的选课信息打印出来（及格则得对应课程的学分），并汇总其选课课程数。打印格式如下（按学号和课程名升序排列，使用rpad对齐打印，其中学号占10个长度，课程名占10个长度，成绩占10个长度）：
    学号      课程名    成绩      所得学分
    ===========================================（40个等号）
    001       数据库    70        3
    001       C语言     55        0  （说明：没有及格，不能得学分）
    001       数据结构  68        4
    001       离散数学  40        0
    ————————————–（35个减号）
    001同学的选课数：4门
    ===========================================（40个等号）
    004       数据库    90        3
    004       汇编语言  88        3
    004       Java编程  92        3
    ————————————–（35个减号）
    004同学的选课数：3门
--******************************************************--
declare
v_rc sys_refcursor;
vsno sc.sno%type;
vcname varchar(20);
vgrade smallint;
vccredit smallint;
countsno char(10):='000';
countcno int:=0;
begin
open v_rc for select sno,cname,grade,ccredit 
    from sc,course 
    where sc.cno = course.cno 
    and sno in (select sno from student where ssex='m') order by 1,2;
fetch v_rc into vsno,vcname,vgrade,vccredit;
dbms_output.put_line(rpad('学号',10)||rpad('课程名',10)||rpad('成绩',10)||rpad('所得学分',10));
while v_rc%found loop

if(countsno != vsno) then
dbms_output.put_line(rpad('=',40,'='));
countsno := vsno;
countcno := 0;
end if;

if(vgrade >= 60) then
dbms_output.put_line(rpad(trim(vsno),10)||rpad(vcname,10)||rpad(vgrade,10)||vccredit);
else
dbms_output.put_line(rpad(trim(vsno),10)||rpad(vcname,10)||rpad(vgrade,10)||'0');
end if;
fetch v_rc into vsno,vcname,vgrade,vccredit;
countcno := countcno+1;
if(countsno != vsno) then
dbms_output.put_line(rpad('-',35,'-'));
dbms_output.put_line(trim(countsno)||'同学的选课数：'||countcno||'门');
end if;
end loop;
dbms_output.put_line(rpad('-',35,'-'));
dbms_output.put_line(trim(countsno)||'同学的选课数：'||countcno||'门');
close v_rc;
end;

# 函数
1、创建函数Fs1，传入课程号，返回字符型。返回该课程的先行课名。若该课程不存在，则返回格式如下(3)所示，若该课程没有先行课，则返回格式如下（2）所示。
要求：
1、不能在函数中使用dbms_output.put_line打印数据，必须是通过Return将结果传出。
2、创建完函数后，请使用匿名块多次调用该函数，分别按顺序传入‘C06’，‘C01’，‘C001’。并将返回的结果分别打印出来。
    输出格式说明：
    (1)若传入课程有先行课（冒号为中文状态下的冒号）：
        （通过传入的课程号查询出的课程名）课程的先行课为：（先行课名）
        例如：Oracle课程的先行课为：数据库
    (2)若传入的课程没有先行课（cpno为null）：
        （通过传入的课程号查询出的课程名）课程没有先行课。
    (3)若传入的课程不存在：
        （传入的课程号）课程不存在。

2、创建函数Fs2，传入学生学号，返回数值型。返回该学生选课的成绩的课程数，若该学生不存在，则返回-1。
要求：
1、不能在函数中使用dbms_output.put_line打印数据，必须是通过Return将结果传出。
2、创建完函数后，请使用匿名块调用该函数，多次调用函数，分别按顺序传入‘001’，‘018’，‘123’。并将返回的结果分别按要求打印出来。
    若返回-1，则打印：
        001号同学不存在。
    若返回选课数，则打印（冒号为中文状态下的冒号）：
        001号同学的选课门数为：（返回的选课数）
--***********1、完成函数第一题的创建*****************
create or replace function Fs1(vcno in char)
return varchar2
is 
cname1 varchar(20);
vcpno char(10);
vcname varchar(20);
begin
  select cpno,cname into vcpno,vcname from course where cno=vcno;
  if(vcpno is null) then
           return (vcname||'课程没有先行课。');
  end if;
  select cname into cname1 from course where cno = vcpno;
  return (vcname||'课程的先行课为：'||cname1);
  exception when no_data_found  then
            return (vcno||'课程不存在。');     
end;

--***********End*******************************************
/

--***********完成测试程序*****************
begin
    dbms_output.put_line(Fs1('C06'));
    dbms_output.put_line(Fs1('C01'));
    dbms_output.put_line(Fs1('C001'));
end;
--***********End*******************************************
/


--***********2、完成函数第二题*****************
create or replace function Fs2(vsno char)
return int
is
vcount int;
vcount2 int;
begin
  select count(*) into vcount from sc where sno=vsno;
  select count(*) into vcount2 from student where sno=vsno;
  if(vcount2=0) then
    return -1;
  end if;
  return vcount;
end;


--***********End*******************************************
/
--***********完成测试程序*****************
begin
    if(Fs2('001')=-1)then
        dbms_output.put_line('001号同学不存在。');
    else 
        dbms_output.put_line('001号同学的选课门数为：'||Fs2('001'));
    end if;
    if(Fs2('018')=-1)then
        dbms_output.put_line('018号同学不存在。');
    else 
        dbms_output.put_line('018号同学的选课门数为：'||Fs2('018'));
    end if;
    if(Fs2('123')=-1)then
        dbms_output.put_line('123号同学不存在。');
    else 
        dbms_output.put_line('123号同学的选课门数为：'||Fs2('123'));
    end if;
end;


--***********End*******************************************
/

# 存储过程1
1、创建存储过程Ps1，传入课程名，查询该课程的选修情况（按学号升序排列），在存储过程中遍历游标，打印选修情况。使用异常捕获来处理课程不存在的情况，打印格式如下（学号打印长度10，课程号打印长度10）：
说明：原则上在存储过程中是不能通过打印返回结果的，但此题的核心要求是在存储过程中遍历游标，因此此题允许在存储过程中对游标遍历结果进行打印。
要求：创建完存储过程后，请使用匿名块多次调用该存储过程，分别传入“数据库”和“Oracle”。
    输出格式说明：
    （1）课程存在的情况：
      学号    课程号    成绩
      ========================（打印25个等号）
      001     C01      78
      002     C01      -1（成绩为空，则打印成绩为-1）
      003     C01      56
      ========================（打印25个等号）
      （2）课程不存在的情况：
          （输入的课程名）课程不存在。  例如：数据库课程不存在。
          =============================（打印25个等号）

--***********1、完成存储过程的创建*****************
create or replace procedure Ps1(vcname varchar)
is 
vcno course.cno%type;
v_rc sys_refcursor;
r_sc sc%rowtype;
vgrade int;
begin
  select cno into vcno from course where cname = vcname;
  open v_rc for select * from sc where cno=vcno order by 1 ;
  fetch v_rc into r_sc;
  dbms_output.put_line(rpad('学号',10)||rpad('课程号',10)||'成绩');
  dbms_output.put_line(rpad('=',25,'='));
  
  while v_rc%found loop
    if(r_sc.grade is null) then
    vgrade := -1;
    else
      vgrade := r_sc.grade;
    end if;
    dbms_output.put_line(rpad(r_sc.sno,10)||rpad(r_sc.cno,10)||vgrade);
    fetch v_rc into r_sc;
  end loop;
    dbms_output.put_line(rpad('=',25,'='));
  close v_rc;
  exception when no_data_found then
    dbms_output.put_line(vcname||'课程不存在。');
    dbms_output.put_line(rpad('=',25,'='));
end Ps1;


--***********End*******************************************
/

--***********完成测试程序*****************
begin 
Ps1('数据库');
Ps1('Oracle');
end;


--***********End*******************************************
/
# 存储过程2
1、创建存储过程Ps2，传入学生学号，通过字符型out参数输出操作结果。若该生选择了数据库课程，则返回数据库的成绩，返回格式如下(1)所示。若该生没有选择数据库，则判断是否为CS系，若是CS系，则为其选择“数据库”课程（成绩为空），并返回选课成功信息，返回格式如下（2）所示。否则返回该生未选择数据库课程，返回格式如下（3）所示。使用异常捕获来处理学生不存在的情况，若学生不存在，则返回格式如下（4）所示。
要求：
1、不能在存储过程中使用dbms_output.put_line打印数据，必须是通过out参数将结果传出。
2、创建完存储过程后，请使用匿名块多次调用该存储过程，分别按顺序传入学号：002，003，004，040。并分别将接收到的结果打印出来。
    输出格式说明：
    （1）学生存在，并选择了数据库课程（冒号为中文状态下的冒号）：
        （查出来的姓名）同学的系别为：查出来的系别，数据库的成绩为：查出来的成绩（若成绩为空，则打印“未考试”）
        例如：张三同学的系为：CS，数据库的成绩为：80
     (2) 学生存在，但没有选数据库课程，若为CS系的同学，则打印：
        已成功为（查出来的姓名）同学选择了数据库课程。
     (3) 学生存在，但没有选数据库课程，若不是CS系的同学，则打印：
        （查出来的姓名）同学没有选择数据库课程。

（4）学生不存在的情况：
    （传入的学号）号同学不存在。
--***********1、完成存储过程的创建*****************
create or replace procedure Ps2(vsno student.sno%type,outputs out varchar )
is 
vsdept student.sdept%type;
vsname student.sname%type;
vgrade sc.grade%type;
begin
  begin
    select sname,sdept into vsname,vsdept from student where sno=vsno;
    exception when no_data_found then
      outputs:=vsno||'号同学不存在。';
      return;
  end;
  select grade into vgrade from sc where sno=vsno and cno=(select cno from course where cname='数据库');
  if(vgrade is null)then
  outputs:=vsname||'同学的系别为：'||vsdept||'，数据库的成绩为：未考试';
  return;
  end if;
  commit;
  outputs:=vsname||'同学的系别为：'||vsdept||'，数据库的成绩为：'||vgrade;
  exception when no_data_found then
    if(vsdept='CS')then
    outputs:='已成功为'||vsname||'同学选择了数据库课程。';
    else
      outputs:=vsname||'同学没有选择数据库课程。';
    end if;
end;

--***********End*******************************************
/

--***********完成测试程序*****************
declare
outputs varchar(1000);
begin
Ps2('002',outputs);
dbms_output.put_line(outputs);
Ps2('003',outputs);
dbms_output.put_line(outputs);
Ps2('004',outputs);
dbms_output.put_line(outputs);
Ps2('040',outputs);
dbms_output.put_line(outputs);
end;


--***********End*******************************************
/
# 存储过程3
1、创建存储过程Ps3，传入学生姓名，课程名和成绩，使用字符型out参数输出选课结果。假设学生姓名和课程名都不能重复。若该生选择了该课程，则修改成绩为传入的成绩，输出格式如下（5）所示。若该生没有选择该课程，则为该生选择该课程，成绩为传入的成绩，输出格式如下（4）所示。若学生或课程不存在，则输出格式如下（2）（3）所示。若成绩不在0到100分之间，则输出如下(1)所示。
要求：
1、不能在存储过程中使用dbms_output.put_line打印数据，必须是通过out参数将结果传出。
2、创建完存储过程后，请使用匿名块多次调用该存储过程，分别按顺序传入以下数据：
‘符志阶’,’数据库’,86
‘符志阶’,’数据库’,null
‘符志阶s’,’数据库’,86
‘符志阶’,’数据库s’,86
‘符志阶’,’数据库’,120
并分别将接收到的结果打印出来。
    输出格式说明：
    （1）成绩不在0到100分之间：
        成绩必须在0到100分之间。
     (2) 学生不存在：
        （传入的学生姓名）同学不存在。
         例如：张三同学不存在。
     (3) 课程不存在：
         (传入的课程名)课程不存在。
         例如：数据库课程不存在。
     (4) 该生没有选择该课程：
         已经成功为(查出来的学号)号同学选择了(传入的课程名)课程，成绩为(传入的成绩)
         例如：已经成功为001号同学选择了数据库课程，成绩为80
     (5) 该生选择了该课程：
         已将（查出来的学号）号同学（传入的课程名）课程的成绩改为（传入的成绩，若为null，则显示为“未考试”）
         例如：已将001同学数据库课程的成绩改为90
         或者  已将001同学数据库课程的成绩改为未考试

--***********1、完成存储过程的创建*****************
create or replace procedure Ps3(vsname varchar,vcname varchar,vgrade int,outputs out varchar)
is
psno student.sno%type;
pcno course.cno%type;
begin
  if(vgrade<0 or vgrade>100) then
    outputs:='成绩必须在0到100分之间。';
    return;
  end if;
  begin
    select sno into psno from student where sname=vsname;
    exception when no_data_found then
      outputs:=vsname||'同学不存在。';
      return;
  end;
  begin
    select cno into pcno from course where cname=vcname;
    exception when no_data_found then
      outputs:=vcname||'课程不存在。';
      return;
  end;
  update sc set grade=vgrade where sno=psno and cno=pcno;
  if(vgrade is null)then
  outputs:='已将'||trim(psno)||'号同学'||vcname||'课程的成绩改为未考试';
  commit;
  return;
  end if;
  outputs:='已将'||trim(psno)||'号同学'||vcname||'课程的成绩改为'||vgrade;
  if(sql%rowcount=0)then
  insert into sc values(psno,pcno,vgrade);
  outputs:='已经成功为'||trim(psno)||'号同学选择了'||vcname||'课程，成绩为'||vgrade;
  commit;
  return;
  end if;
end Ps3;

--***********End*******************************************
/

--***********完成测试程序*****************
declare
result varchar(1000);
begin
Ps3('符志阶','数据库',86,result);
dbms_output.put_line(result);
Ps3('符志阶','数据库',null,result);
dbms_output.put_line(result);
Ps3('符志阶s','数据库',86,result);
dbms_output.put_line(result);
Ps3('符志阶','数据库s',86,result);
dbms_output.put_line(result);
Ps3('符志阶','数据库',120,result);
dbms_output.put_line(result);

end;


--***********End*******************************************
/

# 包1
一、创建包pks1，包头中定义一个存放学号的变量（如vsno）和一个静态游标，查询学号变量对应的学生的选课信息，列出学号，姓名，课程名，成绩，并按成绩降序排列。
1、在包中创建过程ps1，传入系，将该系平均分最高的学生的学号赋予包头中的学号变量（vsno）（这里假设每个系平均分最高的学生只有一个），若找不到平均分最高的学生，则判断系是否存在，若系不存在，则给学号变量赋值‘-1’，若系存在（该系的学生没有选课），则给学号变量赋值‘-2’。
2、在包中创建函数fs1，传入学号，返回该学生获得的总学分。（必须要成绩及格才能获得对应课程学分）
要求：
1、不能在包中使用dbms_output.put_line打印数据。
2、通过匿名块多次调用pks1包中的ps1，传入‘CS’，‘Es’，‘IOS’系，然后判断pks1.vsno的值，若不是‘-1’或‘-2’，则遍历包头中的游标，将查询到的学生选课信息打印出来（学号，姓名，课程名分别占10个长度），并且调用包中的函数fs1，传入该学号，获取该生获得的总学分，打印格式如下（1）所示。若pks1.vsno的值是‘-1’，则打印格式如下（2）所示。若pks1.vsno的值是‘-2’，则打印格式如下（3）所示。
输出格式说明：
(1)若找到了平均分最高的学生（冒号为中文状态下的冒号）：
        学号     姓名     课程名     成绩
        ==================================（打印35个等号）
        006     张三      数据库    99
        006     张三      C语言     98
        006     张三      数据结构  55
        ==================================（打印35个等号）
        006（pks1.vsno的值）号同学获得的总学分为：8（函数返回的学分）

(2)系不存在（pks1.vsno的值为-1）：
       （传入的系）系不存在。
       例如：CS系不存在。

(3)若系存在，但该系的学生没有选课（pks1.vsno的值为-2）
        （传入的系）系的同学没有选课记录。
        例如：CS系的同学没有选课记录。

--***********1、完成包头的创建*****************
create or replace package pks1 is

vsno student.sno%type;
cursor c1 is select student.sno,sname,cname,grade from student,sc,course 
       where student.sno=vsno and sc.sno=student.sno and course.cno=sc.cno order by 4 desc;
procedure ps1(vsdept student.sdept%type);
function fs1(vsno student.sno%type) return int;

end pks1;


--***********End*******************************************
/

--***********2、完成包体的创建*****************
create or replace package body pks1 is
procedure ps1(vsdept student.sdept%type) 
  is
  scount int;
  begin
    select sno into vsno from sc where sno in (select sno from student where sdept=vsdept) group by sno 
      having avg(grade)=(select max(avg(grade)) from sc where sno in (select sno from student where sdept=vsdept) group by sno);
    exception when no_data_found then
      select count(*) into scount from student where sdept=vsdept; 
      if scount=0 then
        vsno:='-1';
      else 
        vsno:='-2';
      end if;
  end ps1;
function fs1 (vsno student.sno%type) return int
  is
  sumccredit int;
  begin
    select sum(course.ccredit) into sumccredit from sc,course where sno=vsno and grade>59 and sc.cno=course.cno;
    
    return sumccredit;
  end fs1;
end pks1;



--***********End*******************************************
/

--***********完成测试程序*****************
declare 
  -- Local variables here
 vsdept1 student.sdept%type:='CS';
 vsdept2 student.sdept%type:='Es';
vsdept3 student.sdept%type:='IOS';

begin
  -- Test statements here
  pks1.ps1(vsdept1);
  if(pks1.vsno = -1) then
    dbms_output.put_line(vsdept1||'系不存在。');
  elsif (pks1.vsno = -2) then
    dbms_output.put_line(vsdept1||'系的同学没有选课记录。');
  else
    dbms_output.put_line(rpad('学号',10)||rpad('姓名',10)||rpad('课程名',10)||'成绩');
    dbms_output.put_line(rpad('=',35,'='));
    for i in pks1.c1 loop
      dbms_output.put_line(rpad(i.sno,10)||rpad(i.sname,10)||rpad(i.cname,10)||i.grade);
    end loop;
    dbms_output.put_line(rpad('=',35,'='));
     dbms_output.put_line(trim(pks1.vsno)||'号同学获得的总学分为：'||pks1.fs1(pks1.vsno));
  end if;

pks1.ps1(vsdept2);
  if(pks1.vsno = -1) then
    dbms_output.put_line(vsdept2||'系不存在。');
  elsif (pks1.vsno = -2) then
    dbms_output.put_line(vsdept2||'系的同学没有选课记录。');
  else
    dbms_output.put_line(rpad('学号',10)||rpad('姓名',10)||rpad('课程名',10)||'成绩');
    dbms_output.put_line(rpad('=',35,'='));
    for i in pks1.c1 loop
      dbms_output.put_line(rpad(i.sno,10)||rpad(i.sname,10)||rpad(i.cname,10)||i.grade);
    end loop;
    dbms_output.put_line(rpad('=',35,'='));
     dbms_output.put_line(trim(pks1.vsno)||'号同学获得的总学分为：'||pks1.fs1(pks1.vsno));
  end if;


  pks1.ps1(vsdept3);
  if(pks1.vsno = -1) then
    dbms_output.put_line(vsdept3||'系不存在。');
  elsif (pks1.vsno = -2) then
    dbms_output.put_line(vsdept3||'系的同学没有选课记录。');
  else
    dbms_output.put_line(rpad('学号',10)||rpad('姓名',10)||rpad('课程名',10)||'成绩');
    dbms_output.put_line(rpad('=',35,'='));
    for i in pks1.c1 loop
      dbms_output.put_line(rpad(i.sno,10)||rpad(i.sname,10)||rpad(i.cname,10)||i.grade);
    end loop;
    dbms_output.put_line(rpad('=',35,'='));
     dbms_output.put_line(trim(pks1.vsno)||'号同学获得的总学分为：'||pks1.fs1(pks1.vsno));
  end if;


end;


--***********End*******************************************
/

# 包2
1、PS1过程的相关输出值
(1)调用ps1过程时，学生已经选了课程（修改操作）：
        已将（查出来的学号）号同学的（查出来的课程号）号课程成绩从（查询出来的修改以前的成绩，若为空，则显示“未考试”）修改为（传入的成绩，若为空，则显示“未考试”）
        例如：
        已将001号同学的C01号课程成绩从未考试修改为80
        或  已将001号同学的C01号课程成绩从80修改为未考试
        或  已将001号同学的C01号课程成绩从65修改为80

(2)调用ps1过程时，为学生选修了课程（插入操作）：
       （查出来的学号）号同学，选修（查出来的课程号）号课程，成绩为（传入的成绩，若为空，则显示“未考试”）
       例如：
       001号同学，选修了C01号课程，成绩为80
       或  001号同学，选修了C01号课程，成绩为未考试

(3)调用ps1过程时，在为学生选课时，发现课程已经满额了
        （查除的课程号）号课程已经满额了，当前选课人数（查出来的人数），最大选课人数（查出来的最大选课人数）
        例如：
        C01号课程已经满额了，当前选课人数10，最大选课人数10

（4）调用PS1过程时，学生不存在
       （传入的姓名）同学不存在。
       例如：张三同学不存在。

（5）调用PS1过程时，课程不存在
        （传入的课程名）课程不存在。
        例如：数据库不存在。

（6）调用PS1过程时，学生和课程都不存在
        （传入的姓名）同学不存在。（传入的课程名）课程不存在。
        例如：张三同学不存在。数据库课程不存在。

2、调用FS1函数的相关返回值
（7）调用FS1函数时，学生被成功删除
         （传入的学号）号同学已被删除。
         例如：001号同学已被删除。

（8）调用FS1函数时，学生不存在
         （传入的学号）同学不存在。
         例如:001号同学不存在。

3、调用PS2过程的相关输出值
（9）调用PS2过程时，SC_Number表被删除
        SC_Number表被成功删除。

（10）调用PS2过程时：SC_Number表不存在
         SC_Number表不存在。


--***********1、完成包头的创建*****************
create or replace package pks2 is
 procedure ps1(vsname student.sname%type,vcname course.cname%type,vgrade sc.grade%type,vresult out varchar);
 function fs1(vsno student.sno%type) return varchar;
 procedure ps2(vresult out varchar);
  
end pks2;


--***********End*******************************************
/

--***********2、完成包体的创建*****************


create or replace package body pks2 is
 procedure pSCnumber(vsno student.sno%type) is
   isexit int :=0;
 begin
   select count(*) into isexit from user_tables where table_name='SC_NUMBER';
   if(isexit = 0) then
     execute immediate 'create table SC_Number as select sno,count(cno) Scnt from sc group by sno';
   end if;
   
   execute immediate 'update sc_number set scnt = scnt+1 where sno=:1'using vsno;
   if(sql%rowcount=0)then
     execute immediate 'insert into sc_number values(:1,1)'using vsno;
   end if;
   commit;
 end;
 
 procedure ps1(vsname student.sname%type,vcname course.cname%type,vgrade sc.grade%type,vresult out varchar) is
   vsno student.sno%type;
   vcno course.cno%type;
   oldgrade sc.grade%type;
   maxcount course.snumber%type;
   vsnumber course.snumber%type;
   vcount int:=0;
 begin
   begin
     select sno into vsno from student where sname=vsname;
     exception when no_data_found then
       vresult:=vsname||'同学不存在。';
   end;
   
   begin
     select cno,snumber into vcno,vsnumber from course where cname=vcname;
     exception when no_data_found then
       vresult:= vresult||vcname||'课程不存在。';
   end;
   
   if(vresult is not null) then
     return;
   end if;
   select count(*) into vcount from sc where sno=vsno and cno=vcno;
   if(vcount = 1) then
     select grade into oldgrade from sc where sno=vsno and cno=vcno;
   end if;
   update sc set grade = vgrade where sno=vsno and cno=vcno;
   if(sql%rowcount=0)then
     select count(*) into maxcount from sc where cno=vcno;
     if(maxcount>= vsnumber)then
       vresult:=trim(vcno)||'号课程已经满额了，当前选课人数'||maxcount||'，最大选课人数'||vsnumber;
       return;
     end if;
     pSCnumber(vsno);
     insert into sc(sno,cno,grade) values(vsno,vcno,vgrade);
     commit;
     if(vgrade is null) then 
       vresult:=trim(vsno)||'号同学，选修了'||trim(vcno)||'号课程，成绩为'||'未考试';
     end if;
     vresult:=trim(vsno)||'号同学，选修了'||trim(vcno)||'号课程，成绩为'||vgrade;
     
     return;
   end if;


   if(oldgrade is null) then
     vresult:='已将'||trim(vsno)||'号同学的'||trim(vcno)||'号课程成绩从'||'未考试修改为';
   else
     vresult:='已将'||trim(vsno)||'号同学的'||trim(vcno)||'号课程成绩从'||oldgrade||'修改为';
   end if;
   if(vgrade is null) then
     vresult:= vresult||'未考试';
   else
     vresult:= vresult||vgrade;
   end if;
   commit;
 end;

 function fs1(vsno student.sno%type) return varchar is
  begin
    delete from sc where sno=vsno;
    delete from student where sno=vsno;
    if(sql%rowcount=0) then
    commit;
    return vsno||'号同学不存在。';
    end if;
    commit;
    return vsno||'号同学已被删除。';
  end;
 
 procedure ps2(vresult out varchar) is
   isexit int:=0;
 begin
   select count(*) into isexit from user_tables where table_name='SC_NUMBER';
   if(isexit=0) then
     vresult:='SC_Number表不存在。';
     return;
   end if;
   execute immediate'drop table sc_number';
   commit;
   vresult:='SC_Number表被成功删除。';
 end;
  
end pks2;


--***********End*******************************************
/

# 触发器之抛出异常
要求：所有抛出的异常号都定义为-20000。抛出异常语句所在行要与测评结果中的行数对应（可在测评不通过后再调整）。
1、创建触发器tr_Student_update，当修改Student表时，不能修改20岁以上(包括20岁)的同学的系别。抛出的异常提示为：不能修改20岁以上的同学系别。
2、创建触发器tr_Course_Insert，当插入Course表数据是，课程号以X开头的课程，必须要有先行课。抛出异常提示为：课程号以X开头的课程，先行课不能为空。
3、创建触发器tr_SC_Delete，规定不能删除数据库课程的选课信息。抛出的异常提示为：不能删除数据库课程的选课信息。
4、创建触发器tr_SC_Update，当修改学生考试成绩时，若修改的学生是CS系的学生，则成绩只能增加，不能减少，并且不能将成绩修改为null。若不是CS系的同学，则不受控制。若成绩修改比原成绩小，则抛出的异常提示为：CS系学生的成绩只能增加不能减少。若将成绩修改为null，则抛出的异常提示为：CS系学生的成绩不能修改为空。
--***********1、完成第一个触发器的创建*****************
create or replace trigger tr_Student_update
  before update 
  on  student
  for each row

begin
  if (:old.sage>=20) then
  raise_application_error(-20000,'不能修改20岁以上的同学系别。');
  end if;
end tr_Student_update;

--***********2、完成第二个触发器的创建*****************
create or replace trigger tr_Course_Insert 
before insert 
on course 
for each row

begin
if (substr(:new.cno,0,1) = 'X' and :new.cpno is null) then
 raise_application_error(-20000,'课程号以X开头的课程，先行课不能为空。');
end if;
end;

--***********3、完成第三个触发器的创建*****************
create or replace trigger tr_SC_Delete 
before delete 
on sc
for each row
declare 
scno course.cno%type;
begin
select cno into scno from course where cname='数据库';
if(:old.cno = scno) then 
raise_application_error(-20000,'不能删除数据库课程的选课信息。');
end if;
end;

--***********4、完成第四个触发器的创建*****************
create or replace trigger tr_SC_Update 
before update 
on sc
for each row 
declare 
vsdept student.sdept%type;

begin
select sdept into vsdept from student where sno=:old.sno;
if (vsdept ='CS' and :old.grade > :new.grade) then
raise_application_error(-20000,'CS系学生的成绩只能增加不能减少。');
elsif(vsdept ='CS' and :new.grade is null) then

raise_application_error(-20000,'CS系学生的成绩不能修改为空。');
end if;
end;

# 触发器之选课数及级联删除
1、创建student表上的删除触发器，当删除学生信息时，先将该学生的选课信息删除。
测试触发器：在Student表中删除001号同学

2、创建SC表的增删改触发器，维护冗余数据。在Student表中新建Scnt列(学生选课门数，类型为int，初值为0)，并初始化Scnt列数据。在触发器中维护这一冗余列，保证Scnt列数据的正确。
测试触发器：
  1、为019号同学选择C01课程，成绩为空。
  2、将014同学选择C01课程记录的学号修改为015。
  3、删除013学生的所有选课信息。
--***********1、完成触发器的创建*****************
create or replace trigger t_student_D 
before delete on student for each row
begin
 delete from sc where sno=:old.sno;
end;
--***********End*******************************************
/
--********PS.务必在每句SQL语句后打分号************
--***********测试语句**************************************
delete from student where sno='001';
--***********End*******************************************
commit;


--********PS.务必在每句SQL语句后打分号************
--***********为Student表添加一列Scnt（选课门数），并初始化其数据*****************


alter table student add scnt int default 0;
update student set scnt=(select count(*) from sc where sno=student.sno);



--***********End*******************************************
 commit;

--***********1、完成触发器的创建*****************
create or replace trigger t_SC_IUD
before insert or update or delete on sc 
for each row
begin
    if inserting then 
        update student set scnt=scnt+1 where sno=:new.sno;
    end if;

    if deleting then
        update student set scnt=scnt-1 where sno=:old.sno;
    end if;

    if updating then
        update student set scnt=scnt+1 where sno=:new.sno;
        update student set scnt=scnt-1 where sno=:old.sno;
    end if;
end;



--***********End*******************************************
/
--********PS.务必在每句SQL语句后打分号************
--***********测试语句**************************************

insert into sc(sno,cno) values('019','C01');
update sc set sno='015' where sno='014' and cno='C01';
delete from sc where sno='013';


--***********End*******************************************
commit;

# 触发器之总学分
1、创建SC表上的触发器，维护冗余列的数据。在Student表中添加冗余列sumC列(学生的总学分，类型为int，初值为0)，并初始化sumC列数据，只有成绩及格时才能获得课程对应学分。在触发器中维护这一冗余列，保证sumC列数据的正确。
测试要求：请务必在创建了触发器后，在Oracle系统下分别为SC表进行增删改操作，并查看对应的SumC列的数据是否正确。要测试的部分包括：

关于插入的测试
    （1）插入成绩为空的行，然后观察sumc的变化。
    （2）插入成绩不及格的行，然后观察sumc的变化。
    （3）插入成绩及格的行，然后观察sumc的变化。
关于删除的测试
    （4）删除成绩为空的行，然后观察sumc的变化。
    （5）删除成绩不及格的行，然后观察sumc的变化。
    （6）删除成绩及格的行，然后观察sumc的变化。
    （7）删除某一个同学的所有选课记录，然后观察sumc的变化。
关于修改的测试
    （9）将一行的成绩从空修改为不及格，然后观察sumc的变化。
    （10）将一行的成绩从空修改为及格，然后观察sumc的变化。
    （11）将一行的成绩从及格修改为不及格，然后观察sumc的变化。
    （12）将某一个同学的学号修改为另一个学号（例如，将001改为020，其中020是未选课的同学），然后观察sumc的变化。

--********PS.务必在每句SQL语句后打分号************
--***********为Student表添加一列SumC（总学分），并初始化其数据*****************
alter table student add sumc int default 0;
update student set sumc=(select sum(ccredit) from sc,course where sc.cno=course.cno and sno=student.sno and grade>=60);
update student set sumc=0 where sumc is null;

--***********End*******************************************
 commit;

--***********1、完成触发器的创建*****************
create or replace trigger tr_sc_ius
after insert or delete or update on sc
for each row
declare
  vccredit course.ccredit%type;
begin
  if inserting then
    if :new.grade>=60 then
      select ccredit into vccredit from course where cno=:new.cno;
      update student set sumc=sumc+vccredit where sno=:new.sno;
    end if;
  end if;
  if deleting then 
    if :old.grade>=60 then
      select ccredit into vccredit from course where cno=:old.cno;
      update student set sumc=sumc-vccredit where sno=:old.sno;
    end if;
  end if;
  if updating then
    if :new.grade>=60 then
      select ccredit into vccredit from course where cno=:new.cno;
      update student set sumc=sumc+vccredit where sno=:new.sno;
    end if;
    if :old.grade>=60 then
      select ccredit into vccredit from course where cno=:old.cno;
      update student set sumc=sumc-vccredit where sno=:old.sno;
    end if;
    
  end if;
  
end;
--***********End*******************************************
/
# 触发器之总成绩
关于插入的测试
    （1）为某位没有选课的同学选课，插入成绩为空的行，然后观察sumG的变化。
    （2）为某位没有选课的同学选课，插入成绩不为空的行，然后观察sumG的变化。
    （3）为总成绩部位空的同学选课，插入成绩不为空的行，然后观察sumG的变化。
关于删除的测试
    （1）删除成绩为空的行，然后观察sumG的变化。
    （2）删除成绩不为的行，然后观察sumG的变化。
    （3）删除某一个同学的所有选课记录，然后观察sumG的变化。
关于修改的测试
    （1）将一行的成绩从空修改为一份分数，然后观察sumG的变化。
    （2）将一行的成绩从有分数修改空，然后观察sumG的变化。
    （3）将某一个同学的学号修改为另一个学号（例如，将001改为020，其中020是未选课的同学），然后观察sumG的变化。

--********PS.务必在每句SQL语句后打分号************
--***********为Student表添加一列SumG（总成绩），并初始化其数据*****************
alter table student add sumg int default null;
update student set sumg=(select sum(grade) from sc where sno=student.sno);


--***********End*******************************************
 commit;

--***********1、完成触发器的创建*****************
create or replace trigger tr_sc_idu_b
before insert or delete or update on sc
for each row
declare 
    sumgrade sc.grade%type;
begin
  if inserting then
    select sumg into sumgrade from student where sno=:new.sno;
    if :new.grade is not null then
      if sumgrade is null then
        update student set sumg=0 where sno=:new.sno;
        update student set sumg=sumg+:new.grade where sno=:new.sno; 
      else
        update student set sumg=sumg+:new.grade where sno=:new.sno;  
      end if;                                                           
    end if;
  end if;
  if deleting then
    if :old.grade is not null then
      update student set sumg=sumg-:old.grade where sno=:old.sno;
      select sumg into sumgrade from student where sno=:old.sno;
      if sumgrade=0 then 
        update student set sumg=null where sno=:old.sno;
      end if;
    end if;
  end if;
  if updating then
    select sumg into sumgrade from student where sno=:new.sno;
    if :new.grade is not null then
      if sumgrade is null then
        update student set sumg=0 where sno=:new.sno;
        update student set sumg=sumg+:new.grade where sno=:new.sno; 
      else
        update student set sumg=sumg+:new.grade where sno=:new.sno;  
      end if;                                                           
    end if;
    if :old.grade is not null then
      update student set sumg=sumg-:old.grade where sno=:old.sno;
      select sumg into sumgrade from student where sno=:old.sno;
      if sumgrade=0 then 
        update student set sumg=null where sno=:old.sno;
      end if;
    end if;
  end if;
end;


--***********End*******************************************
/
