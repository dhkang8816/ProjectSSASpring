function closePopupAndRefreshParent(fallbackUrl) {
    if (window.opener && !window.opener.closed) {
        try {
            var rootOpener = window.opener;
            while (rootOpener.opener && !rootOpener.opener.closed) {
                rootOpener = rootOpener.opener;
            }
            rootOpener.location.reload();
        } catch (error) {
        }
        window.close();
        return false;
    }

    if (fallbackUrl) {
        window.location.href = fallbackUrl;
    }
    return false;
}


document.addEventListener('submit', function (event) {
    var form = event.target;
    if (!(form instanceof HTMLFormElement)) {
        return;
    }

    if (form.dataset.submitting === 'true') {
        event.preventDefault();
        return;
    }

    form.dataset.submitting = 'true';
    var submitButtons = form.querySelectorAll('button[type="submit"], input[type="submit"]');
    submitButtons.forEach(function (button) {
        button.disabled = true;
        button.setAttribute('aria-disabled', 'true');
    });
});
