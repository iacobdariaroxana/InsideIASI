import { Component, OnInit } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { MatDialog } from '@angular/material/dialog';
import { InstructionsComponent } from 'src/app/instructions/instructions.component';
import { Preferences } from '@capacitor/preferences';

@Component({
  selector: 'app-start',
  templateUrl: './start.component.html',
  styleUrls: ['./start.component.scss'],
})
export class StartComponent implements OnInit {
  roFlag!: boolean;

  constructor(
    public translate: TranslateService,
    private _dialogRef: MatDialog
  ) {
    translate.addLangs(['en', 'ro']);
    
  }

  async ngOnInit() {
    Preferences.get({ key: 'languageFlag' }).then((value) => {
      if(value.value != null){
        this.roFlag = JSON.parse(value.value!);
        this.translate.setDefaultLang('ro');
      } else {
        this.roFlag = true;
        this.translate.setDefaultLang('en');
      }
      // value.value != null
      //   ? (this.roFlag = JSON.parse(value.value!))
      //   : (this.roFlag = true);
    });
  }

  switchLanguage(lang: string): void {
    this.translate.use(lang);
  }

  async switchFromRo() {
    this.switchLanguage('ro');
    await Preferences.set({
      key: 'languageFlag',
      value: 'false',
    });
    this.roFlag = false;
  }

  async switchFromEn() {
    this.switchLanguage('en');
    await Preferences.set({
      key: 'languageFlag',
      value: 'true',
    });
    this.roFlag = true;
  }

  openInfoDialog(): void {
    this._dialogRef.open(InstructionsComponent, {
      hasBackdrop: true,
      panelClass: 'dialog',
    });
  }
}
