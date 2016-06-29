function addClass(el, className) {
  var tab = className.split(' ');
  for (var z = 0; z < tab.length; z++) {
    if (el.classList) {

      el.classList.add(tab[z]);
    }
    else {
      el.className += ' ' + tab[z];
    }
  }

}

function hasClass(el, className) {
  if (el.classList) {
    return el.classList.contains(className);
  }
  else {
    return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
  }
}
function contains(text, item) {
  return text.indexOf(item) > -1;
}
function load (filepath, callback) {
  var request = new XMLHttpRequest();
  request.open('GET', filepath, true);
  request.onload = function () {
    if (request.status >= 200 && request.status < 400) {
      callback(request.responseText);
    }
  };
  request.onerror = function() {
  };
  request.send();
}


load('./lint.log', function (res) {
   // Success!
    // var data = JSON.parse(request.responseText);
    var data = res.trim().replace(/\[3[0-9]m/gi, '').split('\n');
    for (var i = 0; i < data.length; i++) {
      var line = document.createElement('div');
      addClass(line, 'item');
      if (i === data.length - 1) {
        data[i] = data[i].replace('☞', '');
        var totalFatals = document.createElement('div');
        var totalErrors = document.createElement('div');
        var totalWarnings = document.createElement('div');
        var totalFiles = document.createElement('div');
        addClass(totalFatals, 'fatal item');
        addClass(totalErrors, 'error item');
        addClass(totalWarnings, 'warning item');
        addClass(totalFiles, 'info item');
        var totalTab = data[i].replace(' in ', ',').split(',');
        totalFatals.innerHTML = totalTab[0];
        totalErrors.innerHTML = totalTab[1];
        totalWarnings.innerHTML = totalTab[2];
        totalFiles.innerHTML = totalTab[3].replace('.', ' treated');
        line.appendChild(totalFatals);
        line.appendChild(totalErrors);
        line.appendChild(totalWarnings);
        line.appendChild(totalFiles);
        addClass(line, 'total');
      } else {
        if (contains(data[i], '☠')) {
          addClass(line,'fatal');
        } else if (contains(data[i], '✗')) {
          addClass(line, 'error');
        } else if (contains(data[i], '☞')) {
          addClass(line, 'warning');
        }
        if (contains(data[i], '(')) {
          addClass(line, 'sub-info');
        } else if (contains(data[i], '✓')) {
          addClass(line, 'success');
        } else if(data[i] !== ''){
          // load('../.' + data[i].trim().split(' ')[1], function (resLine) {
          //   console.log(resLine);
          // }
          // );

          // load()
        }
      }
      if (!hasClass(line, 'total')) {
        line.innerHTML += data[i];
      }


      var total = document.getElementById('total');
      var errors = document.getElementById('errors');
      var warnings = document.getElementById('warnings');
      var success = document.getElementById('success');

      if (data[i] !== '') {
        if (hasClass(line, 'error'))
          errors.appendChild(line);
        else if (hasClass(line, 'warning'))
          warnings.appendChild(line);
        else if (hasClass(line, 'success'))
          success.appendChild(line);
        else {

          total.appendChild(line);
        }
      }
    }
  });





