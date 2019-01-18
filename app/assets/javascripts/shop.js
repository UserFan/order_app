var MapYa = function () { ymaps.ready(init) };

// $(document).ready(function () {
//   $('.refresh_version_cash').on('ajax:success', function (e, data, status, xhr) {
//
//     var data = e.detail[0]
//   //var name = JSON.parse(xhr.responseText);
//     console.log(data)
//   });
// //https://www.youtube.com/watch?v=oxzDc-JvqKY
// });

function init() {

    var myMap = new ymaps.Map("map", {
            center: [$('#map').data('lat'), $('#map').data('lon')],
            zoom: 16
        }, {
            searchControlProvider: 'yandex#search'
        }),

    // Создаем геообъект с типом геометрии "Точка".
        myGeoObject = new ymaps.GeoObject({
            // Описание геометрии.
            geometry: {
                type: "Point",
                coordinates: [$('#map').data('lat'), $('#map').data('lon')]
            },
            // Свойства.
            properties: {
                // Контент метки.
                hintContent: 'Арыш Мае'
            }
        }, {
            // Опции.
            // Иконка метки будет растягиваться под размер ее содержимого.
           preset: 'islands#redDotIcon'
            // Метку можно перемещать.

        });

        myMap.geoObjects
            .add(myGeoObject)

};


document.addEventListener('turbolinks:load', function () {
  MapYa();
});

// document.addEventListener('turbolinks:load', function () {
//   RefreshVer();
// });
