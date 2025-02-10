self.addEventListener('push', function (event) {
    const title = 'Pontual';
    const options = {
        body: event.data.text()
    };

    event.waitUntil(
        self.registration.showNotification(title, options)
    );
});