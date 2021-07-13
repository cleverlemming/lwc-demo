// helper.js
export const helper = {   
    parseJsonEvents(bigJsonObj) {
        let iterateMe = new Array();
        console.log("processing json events...");

        //get the events
        let arrayLength = bigJsonObj._embedded.events.length;
        console.log('event arrayLength: ' + arrayLength);

        for(let i = 0 ; i < arrayLength; i++) {
            let priceRange = 'price range not provided';
            console.log('Json name: ' + bigJsonObj._embedded.events[i].name);
            console.log('Json id: ' + bigJsonObj._embedded.events[i].id);
            //console.log('event obj: ' + JSON.stringify(bigJsonObj._embedded.events[i]));
            if ("priceRanges" in bigJsonObj._embedded.events[i] ){
                priceRange = '$' + bigJsonObj._embedded.events[i].priceRanges[0].min + ' - $' +  
                bigJsonObj._embedded.events[i].priceRanges[0].max ;
            }
            else{
                console.log('no price range for this event');
            }

            //select image with required image resolution from event image array
            for (let arrKey in bigJsonObj._embedded.events[i].images) {
                //ECMAScript 6
                var picUrl;
                console.log('iterating event images' );
                if(typeof bigJsonObj._embedded.events[i].images[arrKey] !== 'undefined'){
                    if( JSON.stringify(bigJsonObj._embedded.events[i].images[arrKey]).includes('TABLET_LANDSCAPE_LARGE')){
                        picUrl = bigJsonObj._embedded.events[i].images[arrKey].url;
                        //console.log('picUrl: ' + picUrl);
                        break;
                    }
                }
            }

            var carouselEventPage = {
                "id" : bigJsonObj._embedded.events[i].id,
                "name" : bigJsonObj._embedded.events[i].name,
                "picUrl" : picUrl,
                "priceRange" : priceRange,
                "eventUrl" : bigJsonObj._embedded.events[i].url
               }
            console.log(JSON.stringify(carouselEventPage));
            iterateMe.push(carouselEventPage);
         }
        return iterateMe;
    }
}