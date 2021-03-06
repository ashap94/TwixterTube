export const fetchSubscriptions = () => 
    $.ajax({
        url: '/api/subscriptions',
        method: 'GET'
    })

export const createSubscription = (subscription) => {

    debugger

    return $.ajax({
        url: '/api/subscriptions',
        method: "POST",
        data: {subscription}
    })

}

export const getSubscription = (subscription) =>
    $.ajax({
        url: '/api/subscription/show',
        method: 'POST',
        data: {subscription}
    })

export const destroySubscription = (subscription) => {

    debugger

    return $.ajax({
        url: `/api/subscriptions/delete`,
        method: 'POST',
        data: {subscription}
    })

}
