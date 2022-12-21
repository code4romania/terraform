'use-strict';

function redirect(to) {
    return {
        statusCode: 301,
        statusDescription: "Moved Permanently",
        headers: {
            location: {
                value: to,
            },
        },
    };
}

function handler(event) {
    if (['', '/'].includes(event.request.uri)) {
        return redirect('/informatii');
    }

    if (event.request.uri.endsWith('/')) {
        return redirect(event.request.uri.replace(/\/+$/, ''));
    }

    if (event.request.querystring.hasOwnProperty('page')) {
        event.request.uri += '@page=' + event.request.querystring.page.value;
    }

    if (!event.request.uri.includes('.')) {
        event.request.uri += '.html';
    }

    return event.request;
}
