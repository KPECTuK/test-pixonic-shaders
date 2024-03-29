# Тестовое задание Pixonic (шейдеры) #

## Исходный текст задания ##

1. Написать шейдер для смешивания текстур. В сцене должен присутствовать меш карты который рендерится, смешивая в себе 4 текстуры. Смешивание текстур определяется через цвет вертексов в меше. Указать цвет вертексов можно любым способом. Необходимо продемонстрировать смешивание текстур, а также рендер только одной текстуры на тех участках где присутствует только один компонент цвета. Модель освещения должна быть диффузной.
2. Сделать аутлайн. Посередине карты находится башня (можно использовать любой примитив). Нужно рисовать внешний аутлайн башни в случае если часть башни находится за каким либо объектом. Та часть башни которая видна - должна рисоваться обычным дифузом без аутлайна. Цвет аутлайна должен меняться при помощи параметра.

Требования:
Итоговым результатом тестового задания должен быть проект юнити со сценой. В ней должны присутствовать перечисленные ассеты, которые рендерятся в соответствии с ТЗ. Результат нужно предоставить в виде ссылки на репозиторий Git.

Важно помнить, что все решения делаются для мобильных устройств, а значит должны быть реализованы самым оптимальным способом. Объяснить почему выбранные решения являются оптимальными. Должно быть возможным собрать билд с шейдерами на IOS и Android и посмотреть на девайсе.

## Комментарии к тексту ##

В целом текст задания внятный. Объем задачи небольшой. Если я правильно понял задачу, то первый пункт проверяет навыки работы с цветом, второй - понимание пайплайна рендерига. Вопросов не возникло, за исключением определения модели освещения в первом пункте. В этой связи реализовано два набора шейдеров с освещением и без. Предполагаю, что подразумевалось решение, реализованное как unlit.

## Комментарии к решению ##

Проект написан для Unity3D 2018.4.5f1. Представляет из себя набор ассетов, шейдеров и сцену. Материалы и шейдеры разделены на две группы (lit/unlit). Так же, в сцене установлены два стенда по одному на каждую группу.

Состав проекта:

- Scenes/main-lit.scene - единственная сцена проекта, со стендами, демонстрирующими результат работы шейдеров.
- Content/Materials - набор материалов, из них:
     - группа surface - для первого пункта задачи
     - группа tower - для второго пункта задачи
- Content/Meshes - модели, одна из которых включает карту цветов вершин (surface)
- Content/Textures - текстуры для каждого канала цвета вершин, так же используются и для тестирования второго пункта решения
- Scripts/Shaders - набор шейдеров по требованиям задачи

**Решение для первого пункта** написано в двух вариантах, оба, для простоты использования, вынесены в библиотеку (blend.cginc). Информация о цветах вершин для шейдеров находится в модели.

**Решение для второго пункта** представляет из себя трехпроходный шейдер. Проходы по порядку:

 - базовый проход для изображения модели
 - дополнительный проход для маски модели
 - проход обводки

Выбран метод со смещением сетки по нормалям как метод, не использующий трафаретного буфера и постобработку. Метод простой и подходящий для подавляющего большинства мобильных устройств. Не смотря на то что даёт грубое исполнение эффекта, в целом - удовлетворяет условиям поставленной задачи. 

Скомпилированно и запущено на ARM Mali-400 MP4.