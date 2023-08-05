export function openGoogleMaps(lat: number, lng: number, zoom: number = 21) {
  const latLng = `${lat},${lng}`; // Replace with the desired latitude and longitude
  let url = `https://www.google.com/maps/@${latLng},${zoom}z`;
  if (/(android)/i.test(navigator.userAgent)) {
    url = `geo:${latLng}?z=${zoom}`;
  } else if (/(ipod|iphone|ipad)/i.test(navigator.userAgent)) {
    url = `maps://maps.apple.com/?ll=${latLng}&z=${zoom}`;
  }
  window.open(url, '_system');
}
