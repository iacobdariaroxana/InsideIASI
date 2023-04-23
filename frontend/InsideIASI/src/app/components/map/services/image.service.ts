import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { map, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ImageService {
  constructor(private readonly _httpClient: HttpClient) {}
  getImagePlace(image64: string): Observable<string> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type':  'application/json'
      })
    };
    const body = { image64: image64 };
    return this._httpClient
      .post('http://192.168.100.5:8003/image_api', JSON.stringify(body), httpOptions)
      .pipe(
        map<any, string>((response) => {
          return response;
        })
      );
  }
}
