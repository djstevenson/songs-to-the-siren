import { Admin } from '../../pages/admin'
import { verify } from 'crypto';

export class SongListPage extends Admin {
    pageUrl() {
        return '/song/list'
    }

}
