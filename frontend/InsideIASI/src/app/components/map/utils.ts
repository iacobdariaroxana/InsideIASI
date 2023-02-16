import { Camera, CameraResultType } from '@capacitor/camera';
import { ImageService } from './services/image.service';

export async function captureImage() {

}

export function openGoogleMaps(lat: number, lng: number) {
  const latLng = `${lat}, ${lng}`; // Replace with the desired latitude and longitude
  let url = `https://maps.google.com/?q=${latLng}`;
  if (/(android)/i.test(navigator.userAgent)) {
    url = `geo:${latLng}`;
  } else if (/(ipod|iphone|ipad)/i.test(navigator.userAgent)) {
    url = `maps://maps.apple.com/?q=${latLng}`;
  }
  window.open(url, '_system');
}
